<?php

/**
 * @file
 * A basic example of using the Migrate module to import tags from bricolage to taxonomy
 * 
 */


class NewIntTermSQLMigration extends NewIntPSQLMigration {
    public function __construct() {
        
        $this->description = 'Pull tags from legacy database that has been created from newint bricolage system';
        $this->psql_table = 'keyword';
        $this->psql_alias = 'k';
        $this->psql_fields = array('id', 'name');
        parent::__construct(MigrateGroup::getInstance('blog'));


        $this->destination = new MigrateDestinationTerm('newint_tags');

        $this->map = new MigrateSQLMap($this->machineName,
            array(
                'id' => array(
                    'type' => 'int',
                    'length' => 10,
                    'description' => 'NI Tag ID',
                    'alias' => $this->psql_alias,
                )
            ),
            MigrateDestinationTerm::getKeySchema(),
            'legacy'
        );



        //$this->addFieldMapping('tid', 'id');
        $this->addFieldMapping('name', 'name');
        $this->addFieldMapping('description', 'name');


        // We conditionally DNM these fields, so your field mappings will be clean
        // whether or not you have path and or pathauto enabled
        /*if (module_exists('path')) {
            $this->addFieldMapping('path', 'path');

            if (module_exists('pathauto')) {
                $this->addFieldMapping('pathauto', 'path');
            }
        }*/

        $this->addFieldMapping('path')
            ->issueGroup(t('DNM'));
        $this->addFieldMapping('weight')
            ->issueGroup(t('DNM'));
        $this->addFieldMapping('format')
            ->issueGroup(t('DNM'));
        $this->addFieldMapping('parent')
            ->issueGroup(t('DNM'));
        $this->addFieldMapping('parent_name')
            ->issueGroup(t('DNM'));

    }
}

