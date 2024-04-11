import pdfplumber
import pandas as pd

pdf = pdfplumber.open('pone.0020298.s008.pdf')
total_pd = pd.DataFrame()
pdf_columns = list()
data_ = ""
for page in range(1, len(pdf.pages)):
    text = pdf.pages[page].extract_text().splitlines(keepends=True)
    data_ = "".join(text[1:])
    title = text[0]
    with open(text[0].replace('.csv\n', '.txt'), 'a+') as f:
        f.write(data_)
        f.write('\r\n')


# 保存到 CSV 文件
# total_pd.to_csv('pone.0020298.s008.csv', header=True, index=False)
# # 保存到 Excel 文件
# total_pd.to_excel('yaohao.xlsx', header = True, index = False)
