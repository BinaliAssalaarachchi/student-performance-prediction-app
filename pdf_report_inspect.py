import PyPDF2
from pathlib import Path
path = Path(r'C:\Users\ASUS\Desktop\BCS Project\BCS\Binali Assalaarachchi - Project Report.pdf')
reader = PyPDF2.PdfReader(path)
for i,page in enumerate(reader.pages[:40]):
    text = page.extract_text() or ''
    if i < 20 or i in {21,22,23,24,25,31,32,33,34,35,36,37,38,39}:
        print(f'--- PAGE {i+1} ---')
        print(text)
        print()
