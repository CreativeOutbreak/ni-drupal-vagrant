<?php

/**
 * @file
 * Basic abstract classes to be inherited from 
 */

class JoinObj {
    public $type;
    public $table;
    public $table_alias;
    public $on;
    public $add_field;

    function JoinObj($type, $table, $alias, $on, $fields = array()) {
        $this->type = $type;
        $this->table = $table;
        $this->table_alias = $alias;
        $this->on = $on;
        $this->add_field = $fields;
    }
}

?>
