import os, csv, io
from datetime import datetime
from functools import wraps
from flask import Flask, render_template, request, redirect, url_for, flash, session, send_file, abort
from werkzeug.security import generate_password_hash, check_password_hash
from werkzeug.utils import secure_filename
import mysql.connector
from mysql.connector import IntegrityError
from dotenv import load_dotenv

load_dotenv()
app = Flask(__name__)
app.secret_key = os.getenv('SECRET_KEY', 'ganti-secret-key-ini-sebelum-deploy')
UPLOAD_FOLDER = os.path.join('static', 'uploads')
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
app.config['MAX_CONTENT_LENGTH'] = 4 * 1024 * 1024
ALLOWED = {'png', 'jpg', 'jpeg', 'webp'}
os.makedirs(UPLOAD_FOLDER, exist_ok=True)

def db():
    return mysql.connector.connect(host=os.getenv('DB_HOST','localhost'), port=int(os.getenv('DB_PORT','3306')), user=os.getenv('DB_USER','root'), password=os.getenv('DB_PASSWORD',''), database=os.getenv('DB_NAME','db_voting_kakang_senduk'))

def query(sql, params=(), one=False, commit=False):
    conn=db(); cur=conn.cursor(dictionary=True)
    try:
        cur.execute(sql, params)
        if commit: conn.commit(); return cur.lastrowid
        return cur.fetchone() if one else cur.fetchall()
    finally: cur.close(); conn.close()

def login_required(fn):
    @wraps(fn)
    def wrapped(*a, **kw):
        if not session.get('user_id'):
            flash('Silakan login terlebih dahulu.', 'warning'); return redirect(url_for('login', next=request.path))
        return fn(*a, **kw)
    return wrapped

def admin_required(fn):
    @wraps(fn)
    def wrapped(*a, **kw):
        if not session.get('user_id') or session.get('role') != 'admin': abort(403)
        return fn(*a, **kw)
    return wrapped

def active_period():
    return query("SELECT * FROM periode_voting WHERE status='Aktif' AND NOW() BETWEEN tanggal_mulai AND tanggal_selesai ORDER BY id DESC LIMIT 1", one=True)

def has_voted(uid, category):
    return bool(query('SELECT id FROM voting WHERE user_id=%s AND kategori=%s', (uid,category), one=True))

def save_photo(file):
    if not file or not file.filename: return None
    name=secure_filename(file.filename)
    ext=name.rsplit('.',1)[-1].lower() if '.' in name else ''
    if ext not in ALLOWED: raise ValueError('Format foto harus PNG, JPG, JPEG, atau WEBP.')
    import uuid
    filename=f'{uuid.uuid4().hex}.{ext}'
    file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))
    return filename

@app.context_processor
def common():
    return {'current_user': session.get('nama'), 'is_admin': session.get('role')=='admin', 'current_year': datetime.now().year}

@app.route('/')
def index():
    counts=query("SELECT kategori, COUNT(*) total FROM kontestan GROUP BY kategori")
    return render_template('index.html', period=active_period(), counts={x['kategori']:x['total'] for x in counts})

@app.route('/kontestan')
def contestants():
    cat=request.args.get('kategori','')
    search=request.args.get('q','').strip()
    sql='SELECT * FROM kontestan WHERE 1=1'; p=[]
    if cat in ('Kakang','Senduk'): sql+=' AND kategori=%s'; p.append(cat)
    if search: sql+=' AND (nama LIKE %s OR nomor_peserta LIKE %s OR asal_instansi LIKE %s)'; p += [f'%{search}%']*3
    sql+=' ORDER BY kategori, nomor_peserta'
    return render_template('contestants.html', contestants=query(sql,p), category=cat, search=search)

@app.route('/kontestan/<int:cid>')
def contestant_detail(cid):
    c=query('SELECT * FROM kontestan WHERE id=%s',(cid,),one=True)
    if not c: abort(404)
    return render_template('detail.html', c=c)

@app.route('/register', methods=['GET','POST'])
def register():
    if request.method=='POST':
        nama=request.form.get('nama','').strip(); email=request.form.get('email','').strip().lower(); hp=request.form.get('no_hp','').strip(); pw=request.form.get('password','')
        if not nama or not email or not pw or len(pw)<8:
            flash('Lengkapi data. Password minimal 8 karakter.', 'danger')
        else:
            try:
                query('INSERT INTO users(nama,email,no_hp,password,role) VALUES(%s,%s,%s,%s,\'pemilih\')',(nama,email,hp,generate_password_hash(pw)),commit=True)
                flash('Registrasi berhasil. Silakan login.', 'success'); return redirect(url_for('login'))
            except IntegrityError: flash('Email sudah terdaftar.', 'danger')
    return render_template('auth.html', mode='register')

@app.route('/login', methods=['GET','POST'])
def login():
    if request.method=='POST':
        email=request.form.get('email','').strip().lower(); pw=request.form.get('password','')
        u=query('SELECT * FROM users WHERE email=%s',(email,),one=True)
        if u and check_password_hash(u['password'],pw):
            session.clear(); session.update(user_id=u['id'],nama=u['nama'],role=u['role'])
            return redirect(url_for('admin_dashboard' if u['role']=='admin' else 'index'))
        flash('Email atau password salah.', 'danger')
    return render_template('auth.html', mode='login')

@app.route('/logout')
def logout(): session.clear(); flash('Kamu sudah logout.','success'); return redirect(url_for('index'))

@app.route('/voting', methods=['GET','POST'])
@login_required
def voting():
    period=active_period()
    if request.method=='POST':
        if not period: flash('Voting sedang tidak dibuka.','warning'); return redirect(url_for('voting'))
        cid=request.form.get('kontestan_id',type=int)
        c=query('SELECT * FROM kontestan WHERE id=%s',(cid,),one=True)
        if not c: flash('Kontestan tidak ditemukan.','danger'); return redirect(url_for('voting'))
        try:
            conn=db(); cur=conn.cursor()
            cur.execute('INSERT INTO voting(user_id,kontestan_id,kategori,created_at) VALUES(%s,%s,%s,NOW())',(session['user_id'],c['id'],c['kategori']))
            conn.commit(); cur.close(); conn.close()
            flash(f'Suara untuk {c["nama"]} berhasil disimpan. Suara tidak dapat diubah.','success')
        except IntegrityError:
            try: conn.rollback(); cur.close(); conn.close()
            except: pass
            flash(f'Kamu sudah memberikan suara kategori {c["kategori"]}.','danger')
        return redirect(url_for('voting'))
    items=query('SELECT * FROM kontestan ORDER BY kategori, nomor_peserta')
    voted={cat:has_voted(session['user_id'],cat) for cat in ('Kakang','Senduk')}
    return render_template('voting.html', contestants=items, period=period, voted=voted)

@app.route('/klasemen')
def leaderboard():
    data=query('''SELECT k.*, COUNT(v.id) total_suara FROM kontestan k LEFT JOIN voting v ON v.kontestan_id=k.id GROUP BY k.id ORDER BY k.kategori, total_suara DESC, k.nomor_peserta''')
    totals={cat:sum(x['total_suara'] for x in data if x['kategori']==cat) for cat in ('Kakang','Senduk')}
    return render_template('leaderboard.html', data=data, totals=totals, updated=datetime.now())

@app.route('/admin')
@admin_required
def admin_dashboard():
    stats={
      'kontestan':query('SELECT COUNT(*) n FROM kontestan',one=True)['n'],
      'pemilih':query("SELECT COUNT(*) n FROM users WHERE role='pemilih'",one=True)['n'],
      'kakang':query("SELECT COUNT(*) n FROM voting WHERE kategori='Kakang'",one=True)['n'],
      'senduk':query("SELECT COUNT(*) n FROM voting WHERE kategori='Senduk'",one=True)['n']}
    period=query('SELECT * FROM periode_voting ORDER BY id DESC LIMIT 1',one=True)
    chart=query('SELECT kategori, COUNT(*) total FROM voting GROUP BY kategori')
    return render_template('admin_dashboard.html',stats=stats,period=period,chart=chart)

@app.route('/admin/kontestan', methods=['GET','POST'])
@admin_required
def admin_contestants():
    if request.method=='POST':
        try:
            photo=save_photo(request.files.get('foto'))
            query('INSERT INTO kontestan(nomor_peserta,nama,kategori,foto,asal_instansi,tempat_lahir,tanggal_lahir,visi,misi,prestasi,deskripsi) VALUES(%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)',(
             request.form['nomor_peserta'],request.form['nama'],request.form['kategori'],photo,request.form.get('asal_instansi'),request.form.get('tempat_lahir'),request.form.get('tanggal_lahir') or None,request.form.get('visi'),request.form.get('misi'),request.form.get('prestasi'),request.form.get('deskripsi')),commit=True)
            flash('Kontestan berhasil ditambahkan.','success')
        except Exception as e: flash(str(e),'danger')
        return redirect(url_for('admin_contestants'))
    return render_template('admin_contestants.html', contestants=query('SELECT * FROM kontestan ORDER BY kategori,nomor_peserta'))

@app.route('/admin/kontestan/<int:cid>/edit', methods=['GET','POST'])
@admin_required
def edit_contestant(cid):
    c=query('SELECT * FROM kontestan WHERE id=%s',(cid,),one=True)
    if not c: abort(404)
    if request.method=='POST':
        try:
            photo=save_photo(request.files.get('foto')) or c['foto']
            query('UPDATE kontestan SET nomor_peserta=%s,nama=%s,kategori=%s,foto=%s,asal_instansi=%s,tempat_lahir=%s,tanggal_lahir=%s,visi=%s,misi=%s,prestasi=%s,deskripsi=%s WHERE id=%s',(
             request.form['nomor_peserta'],request.form['nama'],request.form['kategori'],photo,request.form.get('asal_instansi'),request.form.get('tempat_lahir'),request.form.get('tanggal_lahir') or None,request.form.get('visi'),request.form.get('misi'),request.form.get('prestasi'),request.form.get('deskripsi'),cid),commit=True)
            flash('Data kontestan diperbarui.','success'); return redirect(url_for('admin_contestants'))
        except Exception as e: flash(str(e),'danger')
    return render_template('contestant_form.html',c=c)

@app.post('/admin/kontestan/<int:cid>/hapus')
@admin_required
def delete_contestant(cid):
    query('DELETE FROM kontestan WHERE id=%s',(cid,),commit=True); flash('Kontestan dihapus.','success'); return redirect(url_for('admin_contestants'))

@app.route('/admin/pemilih')
@admin_required
def admin_voters(): return render_template('voters.html', voters=query("SELECT id,nama,email,no_hp,created_at FROM users WHERE role='pemilih' ORDER BY id DESC"))

@app.route('/admin/periode',methods=['GET','POST'])
@admin_required
def periods():
    if request.method=='POST':
        try:
            query("INSERT INTO periode_voting(nama_periode,tanggal_mulai,tanggal_selesai,status) VALUES(%s,%s,%s,%s)",(request.form['nama_periode'],request.form['tanggal_mulai'].replace('T',' '),request.form['tanggal_selesai'].replace('T',' '),request.form.get('status','Nonaktif')),commit=True)
            flash('Periode voting disimpan.','success')
        except Exception as e: flash(str(e),'danger')
        return redirect(url_for('periods'))
    return render_template('periods.html',periods=query('SELECT * FROM periode_voting ORDER BY id DESC'))

@app.post('/admin/periode/<int:pid>/status')
@admin_required
def period_status(pid):
    status=request.form.get('status')
    if status=='Aktif': query("UPDATE periode_voting SET status='Nonaktif'")
    query('UPDATE periode_voting SET status=%s WHERE id=%s',(status,pid),commit=True)
    flash('Status periode diperbarui.','success'); return redirect(url_for('periods'))

@app.route('/admin/hasil')
@admin_required
def admin_results(): return render_template('admin_results.html',data=query('SELECT k.id,k.nomor_peserta,k.nama,k.kategori,COUNT(v.id) total_suara FROM kontestan k LEFT JOIN voting v ON v.kontestan_id=k.id GROUP BY k.id ORDER BY k.kategori,total_suara DESC'))

@app.route('/admin/hasil.csv')
@admin_required
def export_csv():
    rows=query('SELECT k.nomor_peserta,k.nama,k.kategori,COUNT(v.id) total_suara FROM kontestan k LEFT JOIN voting v ON v.kontestan_id=k.id GROUP BY k.id ORDER BY k.kategori,total_suara DESC')
    out=io.StringIO(); w=csv.writer(out); w.writerow(['Nomor','Nama','Kategori','Jumlah Suara'])
    for r in rows: w.writerow([r['nomor_peserta'],r['nama'],r['kategori'],r['total_suara']])
    mem=io.BytesIO(out.getvalue().encode('utf-8-sig')); mem.seek(0)
    return send_file(mem,mimetype='text/csv',as_attachment=True,download_name='hasil-voting.csv')

@app.errorhandler(403)
def forbidden(e): return render_template('error.html',code=403,message='Halaman ini hanya untuk administrator.'),403
@app.errorhandler(404)
def not_found(e): return render_template('error.html',code=404,message='Halaman atau data tidak ditemukan.'),404

if __name__=='__main__': app.run(debug=True)
