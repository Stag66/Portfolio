import requests_html
from rich import console
import webbrowser

session = requests_html.HTMLSession()
language = 'en'
console = console.Console()

search_term = console.input("Insert seach term here: ")
url = f'https://{language}.wikipedia.org/w/index.php?search={search_term}&fulltext=1&ns0=1'
url_result = session.get(url)
search_results = url_result.html.find('.mw-search-result')
urls = []

for num,result in enumerate(search_results):
    title = result.find('.mw-search-result-heading', first=True)
    summary = result.find('.searchresult', first=True).text
    data = result.find('.mw-search-result-data', first=True).text
    urls.append(result.find('.mw-search-result-heading', first=True).absolute_links.pop())
    console.print(f'[blue]{num}\t{title.absolute_links.pop()}\n\t[white]{summary}\n\t[green]{data}\n')
    
selected_item = int(console.input("Select the number of the article you would like to open: "))
webbrowser.open(urls[selected_item])

#
