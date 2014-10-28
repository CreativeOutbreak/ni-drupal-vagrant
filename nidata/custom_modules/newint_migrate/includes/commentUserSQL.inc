<?php

/**
 * @file
 * A basic example of using the Migrate module to import tags from bricolage to taxonomy
 * 
 */


class NewIntCommentUserSQLMigration extends NewIntMigrateComment {
    public $ulist = array(); 
    public function __construct() {
        $this->description = 'Pull users from comments database that has been created from newint commenting system';
        $this->mysql_table = 'users';
        $this->mysql_alias = 'u';
        $this->mysql_fields = array('id', 'display_name', 'real_name', 'email_address');
        parent::__construct(MigrateGroup::getInstance('blog'));

        $this->destination = new MigrateDestinationUser();
        
        $this->map = new MigrateSQLMap($this->machineName,
        array('id' => array(
                'type' => 'int',
                'not null' => TRUE,
                'description' => 'NI ID reference.',
                'alias' => $this->mysql_alias,
                )
             ),
            MigrateDestinationUser::getKeySchema()
        );
        
        $this->addFieldMapping('field_first_name', 'real_name');
        $this->addFieldMapping('field_last_name', 'real_name');

        $this->addFieldMapping('name', 'display_name');
        $this->addFieldMapping('mail', 'email_address');

        $this->addFieldMapping('pass', NULL);
        
        $this->addFieldMapping('role_names', NULL)
            ->defaultValue(t('registered_user'));

        // We conditionally DNM these fields, so your field mappings will be clean
        // whether or not you have path and or pathauto enabled
        /*if (module_exists('path')) {
            $this->addFieldMapping('path', 'path');

            if (module_exists('pathauto')) {
                $this->addFieldMapping('pathauto', 'path');
            }
        }*/

       /* $this->addFieldMapping('status')
            ->issueGroup(t('DNM'));
        $this->addFieldMapping('created')
            ->issueGroup(t('DNM'));
        $this->addFieldMapping('access')
            ->issueGroup(t('DNM'));
        $this->addFieldMapping('login')
            ->issueGroup(t('DNM'));

        $this->addFieldMapping('roles')
            ->issueGroup(t('DNM'));
        
        $this->addFieldMapping('picture')
            ->issueGroup(t('DNM'));
        $this->addFieldMapping('signature')
            ->issueGroup(t('DNM'));

        $this->addFieldMapping('signature_format')
            ->issueGroup(t('DNM'));
        $this->addFieldMapping('timezone')
            ->issueGroup(t('DNM'));
        $this->addFieldMapping('language')
            ->issueGroup(t('DNM'));
        $this->addFieldMapping('theme')
            ->issueGroup(t('DNM'));

        $this->addFieldMapping('init')
            ->issueGroup(t('DNM'));
        $this->addFieldMapping('data')
            ->issueGroup(t('DNM'));
        $this->addFieldMapping('is_new')
            ->issueGroup(t('DNM'));
        $this->addFieldMapping('path')
            ->issueGroup(t('DNM'));
        */
    
    }
    public function prepareRow($row) {

        if(empty($row->email)) {
            $row->email = "example@example.com";
        }
        $login = "";
        if(!empty($row->display_name)) {
            $login = strtolower(str_replace(" ", ".", $row->display_name));
            if(isset($this->ulist[$login])) {
                $this->ulist[$login] += 1;
                $login .= $this->ulist[$login];
            }
            else {
                $this->ulist[$login] = 0;
            }
            $row->display_name = $login;
        }
        else {
        
            if($row->real_name === ""){ $login = "anonymous"; }
            $login = str_replace(" ", "", preg_replace('/[[:^print:]]/', '', $login));
            if(isset($this->ulist[$login])) {
                $this->ulist[$login] += 1;
                $login .= $this->ulist[$login];
            }
            else {
                $this->ulist[$login] = 0;
            }
            $row->display_name = $login;    
        }
         
     return TRUE;
    }

    public function prepare($user, stdClass $row) {
        // Let's pretend we couldn't have done this as easily in prepareRow...
        $user->field_display_name['und'][0]['value'] =  $row->real_name;
    }
}

