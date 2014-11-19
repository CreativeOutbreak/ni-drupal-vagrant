/*  Select all user and there email address if it exists. contact values with an id or 1 or 2 can be email addresses. all other are other contact details like number. */
CREATE VIEW view_users_dis as select distinct on(t1.id) t1.*, t2.login, t2.password, t5.value as email from person t1 left join usr t2 on t1.id = t2.id left join person__contact_value t4 on t1.id = t4.person__id left join (select * from contact_value where contact__id < 3) t5 on t4.contact_value__id = t5.id;

/* Blog stories have an id of 1100, so this just gets the blog stories. */
CREATE VIEW view_blog_story as select * from story where element_type__id = 1100;

/* Blog teasers have a field_type_id of 1247, so this simply gets all the blog teasers */
CREATE VIEW view_blog_teasers as select * from story_field where field_type__id = 1247;
/* Blog body text has a field_type_id of 1248, so this simply gets all the blog body text fields */
CREATE VIEW view_blog_body_text as select * from story_field where field_type__id = 1248;

/* This statment create a view of all the blog articles that are the first ever version of them and no repitition. */
CREATE VIEW view_blog_aticle_v1 as select t1.story__id, t1.version, t1.usr__id, t1.slug, t1.name, t3.short_val as teaser, t4.short_val as body_text from story_instance t1 right join view_blog_story t2 on t1.story__id = t2.id left join view_blog_teasers t3 on t1.id = t3.object_instance_id left join view_blog_body_text t4 on t1.id = t4.object_instance_id where t1.version = 1;

/* This statment is the same as above except it get all versions except the first on. */
CREATE VIEW view_blog_aticle_revisions as select t1.story__id, t1.version, t1.usr__id, t1.slug, t1.name, t3.short_val as teaser, t4.short_val as body_text from story_instance t1 right join view_blog_story t2 on t1.story__id = t2.id left join view_blog_teasers t3 on t1.id = t3.object_instance_id left join view_blog_body_text t4 on t1.id = t4.object_instance_id where t1.version != 1;



CREATE VIEW view_keyword_csv as select t1.story_id, string_agg(t2.name, ',') as keywords from story_keyword t1 left join keyword t2 on t1.keyword_id = t2.id group by t1.story_id order by t1.story_id;


CREATE VIEW view_image_relation as select distinct on(t2.object_instance_id) t2.object_instance_id as story_instance_id, 'http://newint.org' || t1.uri as new_uri from media_instance t1 left join story_element t2 on t1.media__id = t2.related_media__id  where t1.media_type__id = 58 or t1.media_type__id = 60 or t1.media_type__id = 61;




create view view_publish_dates as select max(comp_time) as publish_time, story_instance__id from job group by story_instance__id;

create view view_user_rel as select * from person_member t1 left join migrate_map_newintusersql t2 on t1.object_id = t2.sourceid1;

create view view_contributors as select t1.id, string_agg(to_char(t3.destid1, '99999'), ',') as contrib from story_instance t1 left join story__contributor t2 on t1.id = t2.story_instance__id left join view_user_rel t3 on t2.member__id = t3.member__id group by t1.id;



/* view_blog_article_v1 */
create view view_blog_story_v1 as select t1.id, t1.first_publish_date, t1.publish_date, t1.publish_status, t1.primary_uri, t1.current_version, t1.published_version, t2.keywords, t3.new_uri from view_blog_story t1 left join view_keyword_csv t2 on t1.id = t2.story_id left join view_image_relation t3 on t1.id = t3.story_instance_id;
create view view_blog_instance_v1 as select t1.story__id, t1.version, t1.usr__id, t1.name, t1.slug, t1.note, t2.short_val as teaser, t3.short_val as body_text from story_instance t1 left join view_blog_teasers t2 on t1.id = t2.object_instance_id left join view_blog_body_text t3 on t1.id = t3.object_instance_id where t1.version = 1;
create view view_blog_article_v1 as select distinct on(t1.id) t1.*, t2.version, t2.usr__id, t2.name, t2.slug, t2.teaser, t2.body_text, t2.note from view_blog_story_v1 t1,  view_blog_instance_v1 t2 where t1.id = t2.story__id;
create view view_blog_article_wt_v1 as select distinct on(t1.id) t1.*, t2.publish_time from view_blog_article_v1 t1 left join view_publish_dates t2 on t1.id = t2.story_instance__id;

create view view_blog_article_wtac_v1 as select distinct on(t1.id) t1.*, t2.contrib from view_blog_article_wt_v1 t1 left join view_contributors t2 on t1.id = t2.id;




/* view_blog_article_revisions */

create view view_blog_instance_revisions as select t1.story__id, t1.version, t1.usr__id, t1.name, t1.slug, t1.note, t2.short_val as teaser, t3.short_val as body_text from story_instance t1 left join view_blog_teasers t2 on t1.id = t2.object_instance_id left join view_blog_body_text t3 on t1.id = t3.object_instance_id where t1.version != 1;
create view view_blog_article_revisions as select distinct on(t1.id,t2.version) t1.*, t2.version, t2.usr__id, t2.name, t2.slug, t2.teaser, t2.body_text, t2.note from view_blog_story_v1 t1,  view_blog_instance_revisions t2 where t1.id = t2.story__id;
create view view_blog_article_wt_revisions as select distinct on(t1.id, t1.version) t1.*, t2.publish_time from view_blog_article_revisions t1 left join view_publish_dates t2 on t1.id = t2.story_instance__id;


create view view_blog_article_wid_revisions as select cast((id || '' || version) as int) as rev_id, *, first_publish_date + version * cast('1 second' as interval) as rev_date from view_blog_article_wt_revisions where publish_status = true;

create view view_blog_article_wtac_revisions as select distinct on(t1.id,t1.version) t1.*, t2.contrib from view_blog_article_wid_revisions t1 left join view_contributors t2 on t1.id = t2.id;






/* Test and rubish  */


/*
select story__id, current_version, published_version, first_publish_date, publish_date, publish_status, publish_time from view_blog_article_wt_v1;


select t1.id, string_agg(to_char(t3.object_id, '9999'), ',') as contrib from story_instance t1 left join story__contributor t2 on t1.id = t2.story_instance__id left join person_member t3 on t2.member__id = t3.member__id group by t1.id;


select to_number((id || '' || version), '99999') as rev_id, *, first_publish_date + version * cast('1 second' as interval) as rev_date from view_blog_article_wt_revisions where publish_status = true limit 2;

create view view_blog_article_wtad_revisions as select *, first_publish_date + version * cast('1 second' as interval) as rev_date from view_blog_article_wt_revisions where publish_status = true;


select id, version, current_version, published_version, first_publish_date + version * cast('1 day' as interval) as date, first_publish_date, publish_date, publish_status, publish_time from view_blog_article_wt_revisions where publish_status = true limit 10;

to_char(t2.member__id, '9999')
string_agg(to_char(t2.member__id, '9999'), ',') as member_ids

select distinct on (t1.id) t1.*, string_agg(to_char(t2.member__id, '9999'), ',') as member_ids from person t1, person_member t2 where t1.id = t2.object_id;

select count(*) from person t1, person_member t2 where t1.id = t2.object_id;

select count(*) from person;

string_agg(to_char(member__id, '9999'), ',') as member_ids
create view select story_instance__id, string_agg(to_char(member__id, '99999'), ',') as member_ids from story__contributor group by story_instance__id;


select id, first_publish_date, publish_date, publish_status, primary_uri, keywords, new_uri, version, usr__id, name, slug from view_blog_article_revisions;



string_agg(to_char(comp_time, 'HH12:MI:SS'), ',')
to_char(comp_time, 'HH12:MI:SS')
select string_agg(to_char(comp_time, 'DD-MM-YYYY HH12:MI:SS'), ',') as publis_time, story_instance__id from job group by story_instance__id order by story_instance__id offset 500 limit 20;

select min(comp_time) as publis_time, story_instance__id from job group by story_instance__id order by story_instance__id offset 500 limit 20;

create view view_publish_dates as select max(comp_time) as publish_time, story_instance__id from job group by story_instance__id; */


/* this is a little bit of an odd statment, so I'll explain.  All the refereneces to the keyword/story relation are held in a table called story_keyword.  Unfortunately this give us many rows for each story id.
To get round this I've converted the keyword_id (int) to a 4 char string, hence to_char(keyword_id, '9999').  I then concat the ids seperated by commas.  I then finally group the results by the first (1) selector (story_id in this case).    
CREATE VIEW view_keyword_csv as select story_id, string_agg(to_char(keyword_id, '9999'), ',') as keyword_ids from story_keyword group by 1 order by story_id;

CREATE VIEW view_keyword_csv as select story_id, string_agg(to_char(keyword_id, '9999'), ',') as keyword_ids from story_keyword group by 1 order by story_id;*/


/*select t1.story__id, t1.version, t1.usr__id, t1.slug, t1.name, t3.short_val as teaser, t4.short_val as body_text, t5.first_publish_date from story_instance t1 right join view_blog_story t2 on t1.story__id = t2.id left join view_blog_teasers t3 on t1.id = t3.object_instance_id left join view_blog_body_text t4 on t1.id = t4.object_instance_id left join story t5 on t1.story__id = t5.id  where t1.version != 1;


select t1.story__id, t1.version, t1.usr__id, t1.slug, t5.first_publish_date, t5.publish_date, t5.publish_status from story_instance t1 left join view_blog_story t2 on t1.story__id = t2.id left join view_blog_teasers t3 on t1.id = t3.object_instance_id left join view_blog_body_text t4 on t1.id = t4.object_instance_id left join story t5 on t1.story__id = t5.id  where t1.version = 1 AND t5.publish_status = TRUE; */

/*  Fields needed in blog article request
distinct(t1.story__id), t1.version, t1.usr__id, t1.slug, t1.name, t3.short_val as teaser, t4.short_val as body_text, t5.first_publish_date, t6.keyword_ids
*/

/* I'm not sure this is bringing back all the needed uri's... not sure all the info it always in the uri column.  This is just a test select.
select distinct(t1.story__id), t7.new_uri from story_instance t1 left join view_blog_story t2 on t1.story__id = t2.id left join view_blog_teasers t3 on t1.id = t3.object_instance_id left join view_blog_body_text t4 on t1.id = t4.object_instance_id left join story t5 on t1.story__id = t5.id left join view_keyword_csv t6 on t1.story__id = t6.story_id left join view_image_relation t7 on t1.story__id = t7.story_instance_id where t1.version = 1 AND t5.publish_status = TRUE order by t1.story__id;

select distinct(t1.story__id), t1.version, t1.name, t6.keyword_ids, t7.new_uri from story_instance t1 left join view_blog_story t2 on t1.story__id = t2.id left join view_blog_teasers t3 on t1.id = t3.object_instance_id left join view_blog_body_text t4 on t1.id = t4.object_instance_id left join story t5 on t1.story__id = t5.id left join view_keyword_csv t6 on t1.story__id = t6.story_id left join view_image_relation t7 on t1.story__id = t7.story_instance_id where t1.version = 1 AND t5.publish_status = TRUE order by t1.story__id; */



/* Old Version
CREATE VIEW view_blog_aticle_v1 as select distinct(t1.story__id), t1.version, t1.usr__id, t1.name, t1.slug, t3.short_val as teaser, t4.short_val as body_text, t5.first_publish_date, t5.publish_date, t5.publish_status, t6.keyword_ids, t7.new_uri from story_instance t1 left join view_blog_story t2 on t1.story__id = t2.id left join view_blog_teasers t3 on t1.id = t3.object_instance_id left join view_blog_body_text t4 on t1.id = t4.object_instance_id left join story t5 on t1.story__id = t5.id left join view_keyword_csv t6 on t1.story__id = t6.story_id left join view_image_relation t7 on t1.story__id = t7.story_instance_id where t1.version = 1 AND t5.publish_status = TRUE;

CREATE VIEW view_blog_aticle_revisions as select distinct on(t1.story__id, t1.version) t1.story__id, t1.version, t1.usr__id, t1.name, t1.slug, t3.short_val as teaser, t4.short_val as body_text, t5.first_publish_date, t5.publish_date, t5.publish_status, t6.keyword_ids, t7.new_uri from story_instance t1 left join view_blog_story t2 on t1.story__id = t2.id left join view_blog_teasers t3 on t1.id = t3.object_instance_id left join view_blog_body_text t4 on t1.id = t4.object_instance_id left join story t5 on t1.story__id = t5.id left join view_keyword_csv t6 on t1.story__id = t6.story_id left join view_image_relation t7 on t1.story__id = t7.story_instance_id where t1.version != 1 AND t5.publish_status = TRUE;
*/


/* select count(*) from view_blog_story t1 left join view_keyword_csv t2 on t1.id = t2.story_id left join view_image_relation t3 on t1.id = t3.story_instance_id;*/


/*distinct(t1.story__id), t1.version, t1.usr__id, t1.name, t1.slug, t3.short_val as teaser, t4.short_val as body_text, t5.first_publish_date, t5.publish_date, t5.publish_status, t5.primary_uri, t6.keywords, t7.new_uri as usr_destid

select distinct(t1.story__id), t1.version, t1.usr__id, t1.name, t1.slug, t3.short_val as teaser, t4.short_val as body_text, t5.first_publish_date, t5.publish_date, t5.publish_status, t5.primary_uri, t6.keywords, t7.new_uri, t8.destid1 as usr_destid from view_blog_story t2, story_instance t1, view_blog_teasers t3, view_blog_body_text t4, view_keyword_csv t6, view_image_relation t7 where t2.id = t1.story__id AND t1.id = t3.object_instance_id AND t1.id = t4.object_instance_id AND t2.id = t5.id AND t2.id = t6.story_id AND t2.id = t7.story_instance_id AND t1.version = 1;

select count(*), t2.id from view_blog_story t2, story_instance t1, view_blog_teasers t3, view_blog_body_text t4, view_keyword_csv t6, view_image_relation t7 where t2.id = t1.story__id AND t1.id = t3.object_instance_id AND t1.id = t4.object_instance_id AND t2.id = t6.story_id AND t2.id = t7.story_instance_id AND t1.version = 1 group by t2.id having count(*) > 1;

select t1.story__id, t1.version, t1.usr__id, t1.name, t1.slug, t2.short_val as teaser, t3.short_val as body_text from story_instance t1 left join view_blog_teasers t2 on t1.id = t2.object_instance_id left join view_blog_body_text t3 on t1.id = t3.object_instance_id where t1.version = 1;

create view view_blog_instance_v1 as select t1.story__id, t1.version, t1.usr__id, t1.name, t1.slug, t2.short_val as teaser, t3.short_val as body_text from story_instance t1 left join view_blog_teasers t2 on t1.id = t2.object_instance_id left join view_blog_body_text t3 on t1.id = t3.object_instance_id where t1.version = 1;

create view view_blog_instance_revisions as select t1.story__id, t1.version, t1.usr__id, t1.name, t1.slug, t2.short_val as teaser, t3.short_val as body_text from story_instance t1 left join view_blog_teasers t2 on t1.id = t2.object_instance_id left join view_blog_body_text t3 on t1.id = t3.object_instance_id where t1.version != 1;

create view view_blog_instance_v1 as select t1.story__id, t1.version, t1.usr__id, t1.name, t1.slug, t2.short_val as teaser, t3.short_val as body_text from story_instance t1 left join view_blog_teasers t2 on t1.id = t2.object_instance_id left join view_blog_body_text t3 on t1.id = t3.object_instance_id where t1.version = 1;

select count(*) from story_instance t1 left join view_blog_teasers t2 on t1.id = t2.object_instance_id left join view_blog_body_text t3 on t1.id = t3.object_instance_id where t1.version = 1;

select t1.first_publish_date, t1.publish_date, t1.publish_status, t1.primary_uri, t2.keywords, t3.new_uri from view_blog_story t1 left join view_keyword_csv t2 on t1.id = t2.story_id left join view_image_relation t3 on t1.id = t3.story_instance_id;

select count(*) from view_blog_story t1 left join view_keyword_csv t2 on t1.id = t2.story_id left join view_image_relation t3 on t1.id = t3.story_instance_id left join view_blog_instance_v1 t4 on t1.id = t4.story__id;

select count(*) from view_blog_story t1, view_keyword_csv t2, view_image_relation t3, view_blog_instance_v1 t4 where t1.id = t2.story_id AND t1.id = t3.story_instance_id AND t1.id = t4.story__id;

select count(*) from view_blog_story t1 left join view_keyword_csv t2 on t1.id = t2.story_id left join view_image_relation t3 on t1.id = t3.story_instance_id;

select count(*) from view_blog_story t1 left join view_keyword_csv t2 on t1.id = t2.story_id left join view_image_relation t3 on t1.id = t3.story_instance_id;

select t1.id, t4.name, t1.primary_uri from view_blog_story t1, view_keyword_csv t2, view_image_relation t3, view_blog_instance_v1 t4 WHERE t1.id = t2.story_id AND t1.id = t3.story_instance_id AND t1.id=t4.story__id AND t4.version = 1

create view view_blog_story_v1 as select t1.id, t1.first_publish_date, t1.publish_date, t1.publish_status, t1.primary_uri, t2.keywords, t3.new_uri from view_blog_story t1 left join view_keyword_csv t2 on t1.id = t2.story_id left join view_image_relation t3 on t1.id = t3.story_instance_id;

select count(*) from view_blog_story_v1 left join view_blog_instance_v1 t2 on t1.id = t2.story__id;

select distinct on(t1.id), t1.*, t2.version, t2.usr__id, t2.name, t2.slug, t2.teaser, t2.body_text from view_blog_story_v1 t1,  view_blog_instance_v1 t2 where t1.id = t2.story__id; */






/*


select t1.first_publish_date, t1.publish_date, t1.publish_status, t1.primary_uri, t2.keywords, t3.new_uri from view_blog_story t1 left join view_keyword_csv t2 on t1.id = t2.story_id left join view_image_relation t3 on t1.id = t3.story_instance_id left join (select t1.story__id, t1.version, t1.usr__id, t1.name, t1.slug, t2.short_val as teaser, t3.short_val as body_text from story_instance t1 left join view_blog_teasers t2 on t1.id = t2.object_instance_id left join view_blog_body_text t3 on t1.id = t3.object_instance_id where t1.version = 1) t4 on t1.id = t4.story__id;


select count(*) from (select * from view_blog_story t1 left join view_keyword_csv t2 on t1.id = t2.story_id left join view_image_relation t3 on t1.id = t3.story_instance_id) t1 left join (select t10.story__id, t10.version, t10.usr__id, t10.name, t10.slug, t20.short_val as teaser, t30.short_val as body_text from story_instance t10 left join view_blog_teasers t20 on t10.id = t20.object_instance_id left join view_blog_body_text t30 on t10.id = t30.object_instance_id where t10.version = 1) t4 on t1.id = t4.story__id;






select count(*) from view_blog_story t1 left join story_instance t2 on t1.id = t2.story__id left join view_blog_teasers t3 on t2.id = t3.object_instance_id left join view_blog_body_text t4 on t2.id = t4.object_instance_id left join story t5 on t1.id = t5.id left join view_keyword_csv t6 on t1.id = t6.story_id left join view_image_relation t7 on t1.id = t7.story_instance_id left join migrate_map_newintusersql t8 on t2.usr__id = t8.sourceid1 where t2.version = 1 AND t5.publish_status = TRUE;


CREATE VIEW view_blog_article_v1 as select distinct(t1.story__id), t1.version, t1.usr__id, t1.name, t1.slug, t3.short_val as teaser, t4.short_val as body_text, t5.first_publish_date, t5.publish_date, t5.publish_status, t5.primary_uri, t6.keywords, t7.new_uri, t8.destid1 as usr_destid from view_blog_story t2 left join story_instance t1 on t2.id = t1.story__id left join view_blog_teasers t3 on t1.id = t3.object_instance_id left join view_blog_body_text t4 on t1.id = t4.object_instance_id left join story t5 on t2.id = t5.id left join view_keyword_csv t6 on t2.id = t6.story_id left join view_image_relation t7 on t2.id = t7.story_instance_id left join migrate_map_newintusersql t8 on t1.usr__id = t8.sourceid1 where t1.version = 1 AND t5.publish_status = TRUE;





CREATE VIEW view_blog_article_revisions as select distinct on(t1.story__id, t1.version) t1.story__id, t1.version, t1.usr__id, t1.name, t1.slug, t3.short_val as teaser, t4.short_val as body_text, t5.first_publish_date, t5.publish_date, t5.publish_status, t5.primary_uri, t6.keywords, t7.new_uri, t8.destid1 as usr_destid, t9.destid1 as nid from view_blog_story t2 left join story_instance t1 on t1.story__id = t2.id left join view_blog_teasers t3 on t1.id = t3.object_instance_id left join view_blog_body_text t4 on t1.id = t4.object_instance_id left join story t5 on t1.story__id = t5.id left join view_keyword_csv t6 on t1.story__id = t6.story_id left join view_image_relation t7 on t1.story__id = t7.story_instance_id left join migrate_map_newintusersql t8 on t1.usr__id = t8.sourceid1 left join migrate_map_newintblogarticlesql t9 on t2.id = t9.sourceid1 where t1.version != 1 AND t5.publish_status = TRUE;







CREATE VIEW view_blog_article_v1 as select distinct(t1.story__id), t1.version, t1.usr__id, t1.name, t1.slug, t3.short_val as teaser, t4.short_val as body_text, t5.first_publish_date, t5.publish_date, t5.publish_status, t5.primary_uri, t6.keywords, t7.new_uri from view_blog_story t2 left join story_instance t1 on t1.story__id = t2.id left join view_blog_teasers t3 on t1.id = t3.object_instance_id left join view_blog_body_text t4 on t1.id = t4.object_instance_id left join story t5 on t2.id = t5.id left join view_keyword_csv t6 on t2.id = t6.story_id left join view_image_relation t7 on t2.id = t7.story_instance_id left join migrate_map_newintusersql t8 on t1.usr__id = t8.sourceid1 where t1.version = 1 AND t5.publish_status = TRUE;

select fname, lname from view_users group by lname, fname having count(*) > 1;


story__id, version, usr__id, name, slug, first_publish_date, publish_date, publish_status, primary_uri, keywords, new_uri

select story__id, version, usr__id, name, slug, first_publish_date, publish_date, publish_status, primary_uri, keywords, new_uri from view_blog_article_v1 offset 40 limit 2;

select new_uri from view_blog_article_v1 offset 40 limit 2;

update view_blog_article_v1 set new_uri = "" where story__id = 5728;  3749
update view_blog_article_v1 set new_uri = "" where story__id = 5782;  3710
update view_blog_article_v1 set new_uri = "" where story__id = 5788;  3726
update view_blog_article_v1 set new_uri = "" where story__id = 5918;  3717
update view_blog_article_v1 set new_uri = "" where story__id = 5956;  3710
update view_blog_article_v1 set new_uri = "" where story__id = 6170;  3708
update view_blog_article_v1 set new_uri = "" where story__id = 6186;  3707
update view_blog_article_v1 set new_uri = "" where story__id = 6207;  3718


select related_media__id from story_element where object_instance_id = 6207;

select uri from media_instance where media__id = 3749;

update media_instance set uri = NULL where media__id = 3749;
update media_instance set uri = NULL where media__id = 3710;
update media_instance set uri = NULL where media__id = 3726;
update media_instance set uri = NULL where media__id = 3717;
update media_instance set uri = NULL where media__id = 3710;
update media_instance set uri = NULL where media__id = 3708;
update media_instance set uri = NULL where media__id = 3707;
update media_instance set uri = NULL where media__id = 3718;

migrate_group
*/

/* Test 

select distinct(t1.story__id), t5.primary_uri from view_blog_story t2 left join story_instance t1 on t1.story__id = t2.id left join view_blog_teasers t3 on t1.id = t3.object_instance_id left join view_blog_body_text t4 on t1.id = t4.object_instance_id left join story t5 on t2.id = t5.id left join view_keyword_csv t6 on t2.id = t6.story_id left join view_image_relation t7 on t2.id = t7.story_instance_id where t1.version = 1 AND t5.publish_status = TRUE;

select distinct(t1.story__id), t1.version, t1.usr__id, t1.name, t1.slug, t3.short_val as teaser, t4.short_val as body_text, t5.first_publish_date, t5.publish_date, t5.publish_status, t6.keyword_ids, t7.new_uri from view_blog_story t2 left join story_instance t1 on t1.story__id = t2.id left join view_blog_teasers t3 on t1.id = t3.object_instance_id left join view_blog_body_text t4 on t1.id = t4.object_instance_id left join story t5 on t2.id = t5.id left join view_keyword_csv t6 on t2.id = t6.story_id left join view_image_relation t7 on t2.id = t7.story_instance_id where t1.version = 1 AND t5.publish_status = TRUE;

select count(distinct(t1.story__id)) from view_blog_story t2 left join story_instance t1 on t1.story__id = t2.id left join view_blog_teasers t3 on t1.id = t3.object_instance_id left join view_blog_body_text t4 on t1.id = t4.object_instance_id left join story t5 on t2.id = t5.id left join view_keyword_csv t6 on t2.id = t6.story_id left join view_image_relation t7 on t2.id = t7.story_instance_id where t1.version = 1 AND t5.publish_status = TRUE;


select count(distinct(t1.story__id)) from story_instance t1 left join view_blog_story t2 on t1.story__id = t2.id left join view_blog_teasers t3 on t1.id = t3.object_instance_id left join view_blog_body_text t4 on t1.id = t4.object_instance_id left join story t5 on t1.story__id = t5.id left join view_keyword_csv t6 on t1.story__id = t6.story_id left join view_image_relation t7 on t1.story__id = t7.story_instance_id where t1.version = 1 AND t5.publish_status = TRUE;


select count(distinct(t1.story__id, t1.version)) from view_blog_story t2 left join story_instance t1 on t1.story__id = t2.id left join view_blog_teasers t3 on t1.id = t3.object_instance_id left join view_blog_body_text t4 on t1.id = t4.object_instance_id left join story t5 on t2.id = t5.id left join view_keyword_csv t6 on t2.id = t6.story_id left join view_image_relation t7 on t2.id = t7.story_instance_id where t1.version != 1 AND t5.publish_status = TRUE;
*/


/*select count(distinct(t1.story__id, t1.version)) from story_instance t1 left join view_blog_story t2 on t1.story__id = t2.id left join view_blog_teasers t3 on t1.id = t3.object_instance_id left join view_blog_body_text t4 on t1.id = t4.object_instance_id left join story t5 on t1.story__id = t5.id left join view_keyword_csv t6 on t1.story__id = t6.story_id where t1.version != 1 AND t5.publish_status = TRUE;
*/

/* I'm not sure this is bringing back all the needed uri's... not sure all the info it always in the uri column. */
/*CREATE VIEW view_image_relation as select distinct on(t2.object_instance_id) t2.object_instance_id as story_instance_id, 'http://newint.org' || t1.uri as new_uri from media_instance t1 left join story_element t2 on t1.media__id = t2.related_media__id  where t1.media_type__id = 58 or t1.media_type__id = 60 or t1.media_type__id = 61;*/




/*
select t1.story__id, t1.version, t1.usr__id, t1.slug, t5.first_publish_date, t5.publish_date, t5.publish_status from story_instance t1 left join view_blog_story t2 on t1.story__id = t2.id left join view_blog_teasers t3 on t1.id = t3.object_instance_id left join view_blog_body_text t4 on t1.id = t4.object_instance_id left join story t5 on t1.story__id = t5.id  where t1.version != 1 AND t5.publish_status = TRUE order by t1.story__id;

select count(*) from story_instance t1 left join view_blog_story t2 on t1.story__id = t2.id left join view_blog_teasers t3 on t1.id = t3.object_instance_id left join view_blog_body_text t4 on t1.id = t4.object_instance_id left join story t5 on t1.story__id = t5.id  where t1.version = 1 AND t5.publish_status = TRUE;

select count(*) from story_instance t1 left join view_blog_story t2 on t1.story__id = t2.id left join view_blog_teasers t3 on t1.id = t3.object_instance_id left join view_blog_body_text t4 on t1.id = t4.object_instance_id left join story t5 on t1.story__id = t5.id  where t1.version != 1 AND t5.publish_status = TRUE;

select count(*) from story_instance t1 right join view_blog_story t2 on t1.story__id = t2.id left join view_blog_teasers t3 on t1.id = t3.object_instance_id left join view_blog_body_text t4 on t1.id = t4.object_instance_id left join story t5 on t1.story__id = t5.id  where t5.publish_status = TRUE;

select DISTINCT(t1.story__id), t1.version, t1.usr__id, t1.slug, t5.first_publish_date, t5.publish_date, t5.publish_status from story_instance t1 left join view_blog_story t2 on t1.story__id = t2.id left join view_blog_teasers t3 on t1.id = t3.object_instance_id left join view_blog_body_text t4 on t1.id = t4.object_instance_id left join story t5 on t1.story__id = t5.id  where t1.version = 1 AND t5.publish_status = TRUE;

select count(DISTINCT(t1.story__id)) from story_instance t1 left join view_blog_story t2 on t1.story__id = t2.id left join view_blog_teasers t3 on t1.id = t3.object_instance_id left join view_blog_body_text t4 on t1.id = t4.object_instance_id left join story t5 on t1.story__id = t5.id  where t1.version = 1 AND t5.publish_status = TRUE; */




/* OLD STUFF  */

/* New Versions */
/*
CREATE VIEW view_blog_article_v1 as select distinct(t1.story__id), t1.version, t1.usr__id, t1.name, t1.slug, t3.short_val as teaser, t4.short_val as body_text, t5.first_publish_date, t5.publish_date, t5.publish_status, t5.primary_uri, t6.keywords, t7.new_uri, t8.destid1 as usr_destid from view_blog_story t2 left join story_instance t1 on t1.story__id = t2.id left join view_blog_teasers t3 on t1.id = t3.object_instance_id left join view_blog_body_text t4 on t1.id = t4.object_instance_id left join story t5 on t2.id = t5.id left join view_keyword_csv t6 on t2.id = t6.story_id left join view_image_relation t7 on t2.id = t7.story_instance_id left join migrate_map_newintusersql t8 on t1.usr__id = t8.sourceid1 where t1.version = 1 AND t5.publish_status = TRUE;

CREATE VIEW view_blog_article_revisions as select distinct on(t1.story__id, t1.version) t1.story__id, t1.version, t1.usr__id, t1.name, t1.slug, t3.short_val as teaser, t4.short_val as body_text, t5.first_publish_date, t5.publish_date, t5.publish_status, t5.primary_uri, t6.keywords, t7.new_uri, t8.destid1 as usr_destid, t9.destid1 as nid from view_blog_story t2 left join story_instance t1 on t1.story__id = t2.id left join view_blog_teasers t3 on t1.id = t3.object_instance_id left join view_blog_body_text t4 on t1.id = t4.object_instance_id left join story t5 on t2.id = t5.id left join view_keyword_csv t6 on t2.id = t6.story_id left join view_image_relation t7 on t2.id = t7.story_instance_id left join migrate_map_newintusersql t8 on t1.usr__id = t8.sourceid1 left join migrate_map_newintblogarticlesql t9 on t2.id = t9.sourceid1 where t1.version != 1 AND t5.publish_status = TRUE;


CREATE VIEW view_blog_article_v1 as select distinct(t1.story__id), t1.version, t1.usr__id, t1.name, t1.slug, t3.short_val as teaser, t4.short_val as body_text, t5.first_publish_date, t5.publish_date, t5.publish_status, t5.primary_uri, t6.keywords, t7.new_uri, t8.destid1 as usr_destid from view_blog_story t2 left join story_instance t1 on t1.story__id = t2.id left join view_blog_teasers t3 on t1.id = t3.object_instance_id left join view_blog_body_text t4 on t1.id = t4.object_instance_id left join story t5 on t1.story__id = t5.id left join view_keyword_csv t6 on t1.story__id = t6.story_id left join view_image_relation t7 on t1.story__id = t7.story_instance_id left join migrate_map_newintusersql t8 on t1.usr__id = t8.sourceid1 where t1.version = 1 AND t5.publish_status = TRUE;

CREATE VIEW view_blog_article_revisions as select distinct on(t1.story__id, t1.version) t1.story__id, t1.version, t1.usr__id, t1.name, t1.slug, t3.short_val as teaser, t4.short_val as body_text, t5.first_publish_date, t5.publish_date, t5.publish_status, t5.primary_uri, t6.keywords, t7.new_uri, t8.destid1 as usr_destid, t9.destid1 as nid from view_blog_story t2 left join story_instance t1 on t1.story__id = t2.id left join view_blog_teasers t3 on t1.id = t3.object_instance_id left join view_blog_body_text t4 on t1.id = t4.object_instance_id left join story t5 on t1.story__id = t5.id left join view_keyword_csv t6 on t1.story__id = t6.story_id left join view_image_relation t7 on t1.story__id = t7.story_instance_id left join migrate_map_newintusersql t8 on t1.usr__id = t8.sourceid1 left join migrate_map_newintblogarticlesql t9 on t2.id = t9.sourceid1 where t1.version != 1 AND t5.publish_status = TRUE;




CREATE VIEW view_blog_article_v1 as select distinct(t1.story__id), t1.version, t1.usr__id, t1.name, t1.slug, t3.short_val as teaser, t4.short_val as body_text, t5.first_publish_date, t5.publish_date, t5.publish_status, t5.primary_uri, t6.keywords, t7.new_uri, t8.destid1 as usr_destid from view_blog_story t2 left join story_instance t1 on t2.id = t1.story__id left join view_blog_teasers t3 on t1.id = t3.object_instance_id left join view_blog_body_text t4 on t1.id = t4.object_instance_id left join story t5 on t2.id = t5.id left join view_keyword_csv t6 on t2.id = t6.story_id left join view_image_relation t7 on t2.id = t7.story_instance_id left join migrate_map_newintusersql t8 on t1.usr__id = t8.sourceid1 where t1.version = 1 AND t5.publish_status = TRUE;

CREATE VIEW view_blog_article_revisions as select distinct on(t1.story__id, t1.version) t1.story__id, t1.version, t1.usr__id, t1.name, t1.slug, t3.short_val as teaser, t4.short_val as body_text, t5.first_publish_date, t5.publish_date, t5.publish_status, t5.primary_uri, t6.keywords, t7.new_uri, t8.destid1 as usr_destid, t9.destid1 as nid from view_blog_story t2 left join story_instance t1 on t1.story__id = t2.id left join view_blog_teasers t3 on t1.id = t3.object_instance_id left join view_blog_body_text t4 on t1.id = t4.object_instance_id left join story t5 on t1.story__id = t5.id left join view_keyword_csv t6 on t1.story__id = t6.story_id left join view_image_relation t7 on t1.story__id = t7.story_instance_id left join migrate_map_newintusersql t8 on t1.usr__id = t8.sourceid1 left join migrate_map_newintblogarticlesql t9 on t2.id = t9.sourceid1 where t1.version != 1 AND t5.publish_status = TRUE; */
