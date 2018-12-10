create_git_repository_2() {
	git init

	touch ".hidden/goo"
	
	mkdir "subdirectory"
	touch "subdirectory/foo"
	touch "subdirectory/bar"
	
	touch "foo"
	touch "bar"
}
create_git_repository() {
	git init

	touch .gitignore

	# this will be removed
	echo ".hidden" >> .gitignore	
	mkdir ".hidden"
	touch ".hidden/goo"
	
	mkdir "subdirectory"
	touch "subdirectory/foo"
	touch "subdirectory/bar"

	# this will be removed	
	echo "subdirectory/ignore" >> .gitignore	
	touch "subdirectory/ignore"
	# this will be removed
	echo "subdirectory/.ignore" >> .gitignore	
	touch "subdirectory/.ignore"
	
	touch "foo"
	touch "bar"

	# this will be removed	
	echo ".ignore" >> .gitignore
	touch ".ignore"

	echo "ignore" >> .gitignore	
}
