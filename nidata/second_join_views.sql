
create view view_user_rel as select * from person_member t1 left join migrate_map_newintusersql t2 on t1.object_id = t2.sourceid1;
create view view_contributors as select t1.id, string_agg(to_char(t3.destid1, '99999'), ',') as contrib from story_instance t1 left join story__contributor t2 on t1.id = t2.story_instance__id left join view_user_rel t3 on t2.member__id = t3.member__id group by t1.id;
/* view_blog_article_v1 */
create view view_blog_story_v1 as select t1.id, t1.first_publish_date, t1.publish_date, t1.publish_status, t1.primary_uri, t1.current_version, t1.published_version, t2.keywords, t3.new_uri from view_blog_story t1 left join view_keyword_csv t2 on t1.id = t2.story_id left join view_image_relation t3 on t1.id = t3.story_instance_id;
create view view_blog_instance_v1 as select t1.story__id, t1.version, t1.usr__id, t1.name, t1.slug, t1.note, t2.short_val as teaser, t3.short_val as body_text from story_instance t1 left join view_blog_teasers t2 on t1.id = t2.object_instance_id left join view_blog_body_text t3 on t1.id = t3.object_instance_id where t1.version = 1;
create view view_blog_article_v1 as select distinct on(t1.id) t1.*, t2.version, t2.usr__id, t2.name, t2.slug, t2.teaser, t2.body_text, t2.note from view_blog_story_v1 t1, view_blog_instance_v1 t2 where t1.id = t2.story__id;
create view view_blog_article_wt_v1 as select distinct on(t1.id) t1.*, t2.publish_time from view_blog_article_v1 t1 left join view_publish_dates t2 on t1.id = t2.story_instance__id;
create view view_blog_article_wtac_v1 as select distinct on(t1.id) t1.*, t2.contrib from view_blog_article_wt_v1 t1 left join view_contributors t2 on t1.id = t2.id;
/* view_blog_article_revisions */
create view view_blog_instance_revisions as select t1.story__id, t1.version, t1.usr__id, t1.name, t1.slug, t1.note, t2.short_val as teaser, t3.short_val as body_text from story_instance t1 left join view_blog_teasers t2 on t1.id = t2.object_instance_id left join view_blog_body_text t3 on t1.id = t3.object_instance_id where t1.version != 1;
create view view_blog_article_revisions as select distinct on(t1.id,t2.version) t1.*, t2.version, t2.usr__id, t2.name, t2.slug, t2.teaser, t2.body_text, t2.note from view_blog_story_v1 t1, view_blog_instance_revisions t2 where t1.id = t2.story__id;
create view view_blog_article_wt_revisions as select distinct on(t1.id, t1.version) t1.*, t2.publish_time from view_blog_article_revisions t1 left join view_publish_dates t2 on t1.id = t2.story_instance__id;
create view view_blog_article_wid_revisions as select cast((id || '' || version) as int) as rev_id, *, first_publish_date + version * cast('1 second' as interval) as rev_date from view_blog_article_wt_revisions where publish_status = true;
create view view_blog_article_wtac_revisions as select distinct on(t1.id,t1.version) t1.*, t2.contrib from view_blog_article_wid_revisions t1 left join view_contributors t2 on t1.id = t2.id;

