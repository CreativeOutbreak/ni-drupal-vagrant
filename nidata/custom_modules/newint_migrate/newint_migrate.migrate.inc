<?php

/**
 * @file
 * Because the name of this file is the module name plus '.migrate.inc', when
 * hook_migrate_api is invoked by the Migrate module this file is automatically
 * loaded - thus, you don't need to implement your hook in the .module file.
 */

/*
 * You must implement hook_migrate_api(), setting the API level to 2, if you are
 * implementing any migration classes. As of Migrate 2.5, you should also
 * register your migration and handler classes explicitly here - the former
 * method of letting them get automatically registered on a cache clear will
 * break in certain environments (see http://drupal.org/node/1778952).
 */
function migrate_newint_migrate_api() {
    $api = array(
        'api' => 2,
        'groups' => array(
            'blog' => array(
                'title' => t('Blog'),
            ),
        ),
        'migrations' => array(
            'NewIntTermSQL' => array(
                'class_name' => 'NewIntTermSQLMigration',
                'group_name' => 'blog',
            ),
            'NewIntUserSQL' => array(
                'class_name' => 'NewIntUserSQLMigration',
                'group_name' => 'blog',
            ),
            'NewIntBlogArticleSQL' => array(
                'class_name' => 'NewIntBlogArticleSQLMigration',
                'group_name' => 'blog',
            ),
            'NewIntBlogArticleRevisionSQL' => array(
                'class_name' => 'NewIntBlogArticleRevisionSQLMigration',
                'group_name' => 'blog',
            ),
            /*'NewIntCommentUserSQL' => array(
                'class_name' => 'NewIntCommentUserSQLMigration',
                'group_name' => 'blog',
            ),*/
        ),

    );
    return $api;
}
