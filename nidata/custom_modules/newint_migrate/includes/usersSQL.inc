<?php

/**
 * @file
 * A basic example of using the Migrate module to import tags from bricolage to taxonomy
 * 
 */

//include "classes.inc";

class NewIntUserSQLMigration extends NewIntMigration {
    public $ulist = array(); 
    public function __construct() {
        $this->description = 'Pull users from legacy database that has been created from newint bricolage system';
        $this->psql_table = 'person';
        $this->psql_alias = 't1';
        $this->psql_fields = array('id', 'prefix', 'fname', 'mname', 'lname', 'suffix', 'active');
        parent::__construct(MigrateGroup::getInstance('blog'));
       

        $this->psql_query = $this->getConnection()->select($this->psql_table, $this->psql_alias)
            ->fields($this->psql_alias, $this->psql_fields);
        
       
        $this->psql_query->leftJoin('usr', 't2', "t1.id = t2.id");
        $this->psql_query->fields('t2', array('login', 'password'));
        
        $this->psql_query->leftJoin('person__contact_value', 't3', "t1.id = t3.person__id");
       
        $this->psql_query->leftJoin('contact_value', 't4', "t3.contact_value__id = t4.id");
        
        $this->psql_query->addField('t4', 'value', 'email');

        $this->source = new MigrateSourceSQL($this->psql_query, array(), NULL, array('map_joinable' => FALSE));
        

        $this->destination = new MigrateDestinationUser();
        
        $this->map = new MigrateSQLMap($this->machineName,
        array('id' => array(
                'type' => 'int',
                'not null' => TRUE,
                'description' => 'NI ID reference.',
                'alias' => $this->psql_alias,
                )
             ),
            MigrateDestinationUser::getKeySchema(),
            'legacy'
        );
        
        $this->addFieldMapping('field_first_name', 'fname');
        $this->addFieldMapping('field_last_name', 'lname');

        $this->addFieldMapping('name', 'login');
        $this->addFieldMapping('mail', 'email');

        $this->addFieldMapping('pass', 'password');
        
        $this->addFieldMapping('role_names', 'active')
            ->defaultValue(t('contributor'));

        // We conditionally DNM these fields, so your field mappings will be clean
        // whether or not you have path and or pathauto enabled
        /*if (module_exists('path')) {
            $this->addFieldMapping('path', 'path');

            if (module_exists('pathauto')) {
                $this->addFieldMapping('pathauto', 'path');
            }
        }*/

        $this->addFieldMapping('status')
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
    
    }
    public function prepareRow($row) {

        if(empty($row->password)) {
            $row->active = 'contributor';
        }
        else {
            $row->active = 'administrator';
        }
  
        $row->password = '320noapr';
        if(empty($row->email)) {
            $row->email = "example@example.com";
        }
        $login = "";
        if(!empty($row->login)) {
            $login = $row->login;
            if(isset($this->ulist[$login])) {
                $this->ulist[$login] += 1;
                $login .= $this->ulist[$login];
            }
            else {
                $this->ulist[$login] = 0;
            }
            $row->login = $login;
        }
        else {
        
            if(!empty($row->fname)) {
                $login = trim(strtolower($row->fname));
            }
            if(!empty($row->lname)) {
                $login .= ".".trim(strtolower($row->lname));
            }
            if($login === ""){ $login = "Anonymous"; }
            $login = str_replace(" ", "", preg_replace('/[[:^print:]]/', '', $login));
            if(isset($this->ulist[$login])) {
                $this->ulist[$login] += 1;
                $login .= $this->ulist[$login];
            }
            else {
                $this->ulist[$login] = 0;
            }
            $row->login = $login;    
        }
         
     return TRUE;
    }

    public function prepare($user, stdClass $row) {
        // Let's pretend we couldn't have done this as easily in prepareRow...
        $user->field_display_name['und'][0]['value'] =  $row->fname.' '.$row->lname;
    }
}

