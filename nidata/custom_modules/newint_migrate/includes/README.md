Migration Include Files
=======================
All the classes are pretty self explanitory from their names, but here is a little more detail.


#### [abstracts.inc](https://github.com/CreativeOutbreak/migrate_newint/blob/master/includes/abstracts.inc)
This file contains the abstract bass classes that the actually working migration classes migrate from.

#### [blogArticleRevisionSQL.inc](https://github.com/CreativeOutbreak/migrate_newint/blob/master/includes/blogArticleRevisionSQL.inc)
This class migrates all the blog article revisions. It's pretty much the same as the blog article migration, except it has a version id and it's all article that version != 1, where as the blog article migration only migrates article that version = 1;

#### [blogArticleSQL.inc](https://github.com/CreativeOutbreak/migrate_newint/blob/master/includes/blogArticleSQL.inc)
As explained above, this class is pretty much the same as the blog revision migration except it doesn't except a version number and the database view created for it on hold first version of all the articles.

#### [tagsSQL.inc](https://github.com/CreativeOutbreak/migrate_newint/blob/master/includes/tagsSQL.inc)
Tags(taxonomy) was the first class made for migration as it's the most simple migration of the lot.  It just brings across the name and a short description.

#### [usersSQL.inc](https://github.com/CreativeOutbreak/migrate_newint/blob/master/includes/usersSQL.inc)
User migration is slightly more complicated than tags as it uses the [prepareRow function](https://github.com/CreativeOutbreak/migrate_newint/blob/master/includes/usersSQL.inc#L88) to manipulate the rows before the get inputted.  This was for a couple of reasons, one to [switch the user role depending whether the user has a password or not](https://github.com/CreativeOutbreak/migrate_newint/blob/master/includes/usersSQL.inc#L90-L95) and secondly to [set a defualt email & password](https://github.com/CreativeOutbreak/migrate_newint/blob/master/includes/usersSQL.inc#L97-L100) as we can't decrypt the current passwords and not everyone has an email address.  We also do a little bit of [fiddling with the first and last name](https://github.com/CreativeOutbreak/migrate_newint/blob/master/includes/usersSQL.inc#L101-L111) to make a user name.

