<?php

/**
 * @file
 * Basic abstract classes to be inherited from 
 */


abstract class NewIntMigration extends Migration {
    protected $psql_table;
    protected $psql_alias;
    protected $psql_fields = array('id');
    protected $psql_query;
    protected $psql_joins = array();
    public function __construct($group) {
         
        parent::__construct(MigrateGroup::getInstance('blog')); //NULL); //array($group));
        $this->team = array(new MigrateTeamMember('Pete Stewart', 'pete@newint.org', t('Web Development Manager')));
        $this->issuePattern = 'http://www.hostedredmine.com/issues/:id:';
    }

    public function getConnection($conn = 'legacy') {
        return Database::getConnection('default',$conn);
    }
}


abstract class NewIntPSQLMigration extends NewIntMigration {
    
    public function __construct($group) {

        parent::__construct($group); 
        
        if(isset($this->psql_table) && isset($this->psql_alias)) { 
            $this->psql_query = $this->getConnection()->select($this->psql_table, $this->psql_alias)
                ->fields($this->psql_alias, $this->psql_fields);

            if(!empty($this->psql_joins)) {
                // buid joins
            }
        } 
        $count_query = $this->getConnection()->select($this->psql_table, $this->psql_alias);
        $count_query->addExpression('COUNT(*)', 'cnt');



        $this->source = new MigrateSourceSQL($this->psql_query, array(), NULL, array('map_joinable' => FALSE));
    }
}


abstract class NewIntMigrateComment extends Migration {
    protected $mysql_table;
    protected $mysql_alias;
    protected $mysql_fields = array('id');
    protected $mysql_query;
    public function __construct($group) {
         
        parent::__construct(MigrateGroup::getInstance('blog')); 
        $this->team = array(new MigrateTeamMember('Pete Stewart', 'pete@newint.org', t('Web Development Manager')));
        $this->issuePattern = 'http://www.hostedredmine.com/issues/:id:';

        if(isset($this->mysql_table) && isset($this->mysql_alias)) { 
            $this->mysql_query = $this->getConnection()->select($this->mysql_table, $this->mysql_alias)
                ->fields($this->mysql_alias, $this->mysql_fields);
        } 



        $this->source = new MigrateSourceSQL($this->mysql_query);

    }

    public function getConnection($conn = 'comments') {
        return Database::getConnection('default',$conn);
    }
}


