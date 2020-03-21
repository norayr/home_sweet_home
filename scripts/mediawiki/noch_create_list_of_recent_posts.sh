mysql -uroot -p --database=vishap_oberon -e "select page_title from page where page_touched between 20190601000000 and  20191029000000 and page_namespace = 0 into outfile '/tmp/pagelist.csv'"
