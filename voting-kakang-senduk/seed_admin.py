import os, getpass, mysql.connector
from werkzeug.security import generate_password_hash
from dotenv import load_dotenv
load_dotenv()
c=mysql.connector.connect(host=os.getenv('DB_HOST','localhost'),port=int(os.getenv('DB_PORT','3306')),user=os.getenv('DB_USER','root'),password=os.getenv('DB_PASSWORD',''),database=os.getenv('DB_NAME','db_voting_kakang_senduk'))
name=input('Nama admin [Administrator]: ').strip() or 'Administrator'
email=input('Email admin [admin@voting.local]: ').strip() or 'admin@voting.local'
pw = input('Password admin (minimal 8 karakter): ')
if len(pw)<8: raise SystemExit('Password minimal 8 karakter.')
cur=c.cursor()
cur.execute("INSERT INTO users(nama,email,password,role) VALUES(%s,%s,%s,'admin') ON DUPLICATE KEY UPDATE nama=VALUES(nama), password=VALUES(password), role='admin'",(name,email,generate_password_hash(pw)))
c.commit(); cur.close(); c.close(); print('Akun admin berhasil dibuat/diperbarui.')
