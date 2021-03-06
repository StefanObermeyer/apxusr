--- APEX User Management Data ---


-----------------------------------------------------------------------------------------------------
--
-- Stefan Obermeyer 12.2016
--
-- 12.12.2016 SOB created
-- 27.01.2017 SOB Outfactored into separate file.
--
-----------------------------------------------------------------------------------------------------



--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Sample Data
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Status

-- DEFAULT Status first
INSERT INTO "APEX_APP_STATUS" (APP_STATUS_ID, APP_STATUS, APP_STATUS_CODE, APP_STATUS_SCOPE, APP_ID) 
VALUES ('0', 'DEFAULT', 'DEF', 'ALL', v('FB_FLOW_ID'));
-- Status by Scope
INSERT INTO "APEX_APP_STATUS" (APP_STATUS, APP_STATUS_CODE, APP_STATUS_SCOPE, APP_ID) VALUES ('OPEN', 'OPN', 'ACCOUNT', v('FB_FLOW_ID'));
INSERT INTO "APEX_APP_STATUS" (APP_STATUS, APP_STATUS_CODE, APP_STATUS_SCOPE, APP_ID) VALUES ('LOCKED', 'LCK', 'ACCOUNT', v('FB_FLOW_ID'));
INSERT INTO "APEX_APP_STATUS" (APP_STATUS, APP_STATUS_CODE, APP_STATUS_SCOPE, APP_ID) VALUES ('EXPIRED', 'XPR', 'ACCOUNT', v('FB_FLOW_ID'));
INSERT INTO "APEX_APP_STATUS" (APP_STATUS, APP_STATUS_CODE, APP_STATUS_SCOPE, APP_ID) VALUES ('SUSPENDED', 'SUS', 'ACCOUNT', v('FB_FLOW_ID'));
INSERT INTO "APEX_APP_STATUS" (APP_STATUS, APP_STATUS_CODE, APP_STATUS_SCOPE, APP_ID) VALUES ('UP', 'UP', 'APPLICATION', v('FB_FLOW_ID'));
INSERT INTO "APEX_APP_STATUS" (APP_STATUS, APP_STATUS_CODE, APP_STATUS_SCOPE, APP_ID) VALUES ('DOWN', 'DWN', 'APPLICATION', v('FB_FLOW_ID'));

commit;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Roles 
-- can provide security levels groupwise in a up- or downwards security classification. 
-- In this case we go upwards, means the higher the group_id the higher the privileges, except for root, who is allways allowed to all at any time.
-- So we can ask if the role_id is greater/equal to the security level, or if user has_root (min(users_role_id = 0)) in VPD functions or Authorizations Schemes.
-- and thus the higher the Security Level of an object, item or page the higher the Role Security Level (i.e. the ROLE_ID) needs to be to access it.

-- Public and Internal Roles
INSERT INTO "APEX_APP_ROLE" (APP_ROLE_ID, APP_ROLENAME, APP_ROLE_CODE, APP_ROLE_DESCRIPTION, APP_ROLE_STATUS_ID, APP_ID) 
VALUES ('0', 'PUBLIC', 'PUB', 'Public User', '2', v('FB_FLOW_ID'));

INSERT INTO "APEX_APP_ROLE" (APP_ROLE_ID, APP_ROLENAME, APP_ROLE_CODE, APP_ROLE_DESCRIPTION, APP_ROLE_STATUS_ID, APP_ID) 
VALUES ('1', 'BENUTZER', 'USR', 'Application User.', '1', v('FB_FLOW_ID'));
INSERT INTO "APEX_APP_ROLE" (APP_ROLE_ID, APP_ROLENAME, APP_ROLE_CODE, APP_ROLE_DESCRIPTION, APP_ROLE_STATUS_ID, APP_ID) 
VALUES ('10', 'LESEN', 'READ', 'Application ReadOnly Users (May read but not change Data)', '1', v('FB_FLOW_ID'));
INSERT INTO "APEX_APP_ROLE" (APP_ROLE_ID, APP_ROLENAME, APP_ROLE_CODE, APP_ROLE_DESCRIPTION, APP_ROLE_STATUS_ID, APP_ID) 
VALUES ('20', 'SCHREIBEN', 'WRITE', 'Application ReadWrite Users (May read, write and change Data)', '1', v('FB_FLOW_ID'));

-- Higher Privileged Roles
INSERT INTO "APEX_APP_ROLE" (APP_ROLE_ID, APP_ROLENAME, APP_ROLE_CODE, APP_ROLE_DESCRIPTION, APP_ROLE_STATUS_ID, APP_ID) 
VALUES ('1000', 'ADMINISTRATOR', 'ADM', 'Application Administrators', '1', v('FB_FLOW_ID'));
INSERT INTO "APEX_APP_ROLE" (APP_ROLE_ID, APP_ROLENAME, APP_ROLE_CODE, APP_ROLE_DESCRIPTION, APP_ROLE_STATUS_ID, APP_ID) 
VALUES ('1010', 'MANAGEMENT', 'MGM', 'Company Managers', '1', v('FB_FLOW_ID'));

-- The Super User Role
--INSERT INTO "APEX_APP_ROLE" (APP_ROLE_ID, APP_ROLENAME, APP_ROLE_CODE, APP_ROLE_DESCRIPTION, APP_ROLE_STATUS_ID, APP_ID) 
--VALUES ('1000000', 'ROOT', 'ROOT', 'The Super User Role', '1', v('FB_FLOW_ID'));

commit;


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Default User

-- Public Account a.k.a. ANONYMOUS
INSERT INTO "APEX_APP_USER" (APP_USER_ID, APP_USERNAME, APP_USER_EMAIL, APP_USER_CODE, APP_USER_DESCRIPTION, 
                                                                 APP_USER_STATUS_ID, APP_USER_DEFAULT_ROLE_ID, APP_ID) 
VALUES (0, 'PUBLIC', 'public@myComp.de', 'PUB', 'Application Public Account', 2, 0, v('FB_FLOW_ID'));

-- The Default APEX User (ADMIN) inherited from Workspace
INSERT INTO "APEX_APP_USER" (APP_USER_ID, APP_USERNAME, APP_USER_EMAIL, APP_USER_CODE, APP_USER_DESCRIPTION, 
                                                                 APP_USER_STATUS_ID, APP_USER_DEFAULT_ROLE_ID, APP_ID) 
VALUES (1, 'ADMIN', 'admin@myComp.de', 'ADM', 'Application Admin Account (Apex Default)', 1, 1000, v('FB_FLOW_ID'));

commit;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- System BuiltIn Users and Roles
INSERT INTO "APEX_SYS_BUILTINS" (APP_BUILTIN_ID, APP_ID, APP_USER_ID, APP_ROLE_ID, IS_ADMIN, IS_PUBLIC, IS_DEFAULT)
(select rownum as id,  v('FB_FLOW_ID') as app_id,  app_user_id, 
  null as role_id,
  case when  app_username = 'ADMIN' then 1 else 0 end as is_admin,
  case when  app_username = 'PUBLIC' then 1 else 0 end as is_public,
  1 as is_default
 from "APEX_APP_USER" where app_username in ('PUBLIC', 'ADMIN')
 UNION
 select rownum+2, v('FB_FLOW_ID') as app_id, null, app_role_id,
  case when  app_role_code = 'ADM' then 1 else 0 end as is_admin,
  case when  app_role_code = 'PUB' then 1 else 0 end as is_public,
  1 as is_default
 from "APEX_APP_ROLE" where app_role_code in ('PUB', 'USR', 'ADM'));

commit;


