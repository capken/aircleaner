curl "http://www.coway.com/product/product_thum.asp?bcate=3" | 
egrep -o "idx=\d+" | sort -u | 
xargs -I ID echo "http://www.coway.com/product/product_view.asp?cate_pgae=product_thum.asp&bcate=3&mcate=&ID"
