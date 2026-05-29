import PyPDF2
from pathlib import Path
path = Path(r'C:\Users\ASUS\Desktop\BCS Project\BCS\Binali Assalaarachchi - Project Report.pdf')
reader = PyPDF2.PdfReader(path)
for i in range(10, 41):
    text = reader.pages[i].extract_text() or ''
    print(f'--- PAGE {i+1} ---')
    print(text)
    print()
