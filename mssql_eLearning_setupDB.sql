-- MSSQL does not have a direct equivalent for FOREIGN_KEY_CHECKS
-- This is typically handled through ALTER TABLE statements for specific constraints

-- Check and create o_forum table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_forum' AND xtype='U')
CREATE TABLE o_forum (
   forum_id BIGINT NOT NULL,
   version INT NOT NULL,  -- Changed from MEDIUMINT UNSIGNEDz to INT
   creationdate DATETIME2,  -- Changed from DATETIME to DATETIME2 for more precision
   f_refresname NVARCHAR(50),  -- Changed VARCHAR to NVARCHAR for better Unicode support
   f_refresid BIGINT,
   PRIMARY KEY (forum_id)
);

-- Check and create o_forum_pseudonym table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_forum_pseudonym' AND xtype='U')
CREATE TABLE o_forum_pseudonym (
   id BIGINT NOT NULL IDENTITY(1,1),  -- Changed AUTO_INCREMENT to IDENTITY
   creationdate DATETIME2 NOT NULL,
   p_pseudonym NVARCHAR(255) NOT NULL,  -- Changed VARCHAR to NVARCHAR
   p_credential NVARCHAR(255) NOT NULL,  -- Changed VARCHAR to NVARCHAR
   p_salt NVARCHAR(255) NOT NULL,  -- Changed VARCHAR to NVARCHAR
   p_hashalgorithm NVARCHAR(16) NOT NULL,  -- Changed VARCHAR to NVARCHAR
   PRIMARY KEY (id)
);

-- Check and create o_property table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_property' AND xtype='U')
CREATE TABLE o_property (
   id BIGINT NOT NULL,
   version INT NOT NULL,  -- Changed from MEDIUMINT UNSIGNED to INT
   lastmodified DATETIME2,
   creationdate DATETIME2,
   idprofile BIGINT,  -- Changed from identity to idprofile to avoid reserved word conflict
   grp BIGINT,
   resourcetypename NVARCHAR(50),  -- Changed VARCHAR to NVARCHAR
   resourcetypeid BIGINT,
   category NVARCHAR(33),  -- Changed VARCHAR to NVARCHAR
   name NVARCHAR(255) NOT NULL,  -- Changed VARCHAR to NVARCHAR
   floatvalue FLOAT,  -- Removed precision for compatibility
   longvalue BIGINT,
   stringvalue NVARCHAR(255),  -- Changed VARCHAR to NVARCHAR
   textvalue NVARCHAR(MAX),  -- Changed LONGTEXT to NVARCHAR(MAX)
   PRIMARY KEY (id)
);

-- Check and create o_bs_secgroup table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_bs_secgroup' AND xtype='U')
CREATE TABLE o_bs_secgroup (
   id BIGINT NOT NULL,
   version INT NOT NULL,  -- Changed from MEDIUMINT UNSIGNED to INT
   creationdate DATETIME2,
   PRIMARY KEY (id)
);

-- Check and create o_bs_group table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_bs_group' AND xtype='U')
CREATE TABLE o_bs_group (
   id BIGINT NOT NULL,
   creationdate DATETIME2 NOT NULL,
   g_name NVARCHAR(36),  -- Changed VARCHAR to NVARCHAR
   PRIMARY KEY (id)
);

-- second round

-- Check and create o_bs_group_member table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_bs_group_member' AND xtype='U')
CREATE TABLE o_bs_group_member (
   id BIGINT NOT NULL,
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   g_role NVARCHAR(24) NOT NULL,
   g_inheritance_mode NVARCHAR(16) DEFAULT 'none' NOT NULL,
   fk_group_id BIGINT NOT NULL,
   fk_identity_id BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_bs_grant table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_bs_grant' AND xtype='U')
CREATE TABLE o_bs_grant (
   id BIGINT NOT NULL,
   creationdate DATETIME2 NOT NULL,
   g_role NVARCHAR(32) NOT NULL,
   g_permission NVARCHAR(32) NOT NULL,
   fk_group_id BIGINT NOT NULL,
   fk_resource_id BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_gp_business table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_gp_business' AND xtype='U')
CREATE TABLE o_gp_business (
   group_id BIGINT NOT NULL,
   version INT NOT NULL,
   lastmodified DATETIME2,
   creationdate DATETIME2,
   lastusage DATETIME2,
   status NVARCHAR(32) DEFAULT 'active',
   excludeautolifecycle BIT DEFAULT 0 NOT NULL,  -- Changed BOOL to BIT
   inactivationdate DATETIME2,
   inactivationemaildate DATETIME2,
   reactivationdate DATETIME2,
   softdeleteemaildate DATETIME2,
   softdeletedate DATETIME2,
   data_for_restore NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
   groupname NVARCHAR(255),
   technical_type NVARCHAR(32) DEFAULT 'business' NOT NULL,
   external_id NVARCHAR(64),
   managed_flags NVARCHAR(255),
   descr NVARCHAR(MAX),  -- Changed LONGTEXT to NVARCHAR(MAX)
   minparticipants INT,
   maxparticipants INT,
   waitinglist_enabled BIT,
   autocloseranks_enabled BIT,
   invitations_coach_enabled BIT DEFAULT 0 NOT NULL,  -- Changed BOOL to BIT
   lti_deployment_coach_enabled BIT DEFAULT 0 NOT NULL,  -- Changed BOOL to BIT
   ownersintern BIT DEFAULT 0 NOT NULL,
   participantsintern BIT DEFAULT 0 NOT NULL,
   waitingintern BIT DEFAULT 0 NOT NULL,
   ownerspublic BIT DEFAULT 0 NOT NULL,
   participantspublic BIT DEFAULT 0 NOT NULL,
   waitingpublic BIT DEFAULT 0 NOT NULL,
   downloadmembers BIT DEFAULT 0 NOT NULL,
   allowtoleave BIT DEFAULT 1 NOT NULL,
   fk_resource BIGINT UNIQUE,
   fk_group_id BIGINT UNIQUE,
   fk_inactivatedby_id BIGINT,
   fk_softdeletedby_id BIGINT,
   PRIMARY KEY (group_id)
);

-- Check and create o_temporarykey table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_temporarykey' AND xtype='U')
CREATE TABLE o_temporarykey (
   reglist_id BIGINT NOT NULL,
   version INT NOT NULL,
   creationdate DATETIME2,
   email NVARCHAR(2000) NOT NULL,
   regkey NVARCHAR(255) NOT NULL,
   ip NVARCHAR(255) NOT NULL,
   valid_until DATETIME2,
   mailsent BIT NOT NULL,
   action NVARCHAR(255) NOT NULL,
   fk_identity_id BIGINT,
   PRIMARY KEY (reglist_id)
);

-- Check and create o_bs_authentication table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_bs_authentication' AND xtype='U')
CREATE TABLE o_bs_authentication (
   id BIGINT NOT NULL,
   version INT NOT NULL,
   creationdate DATETIME2,
   lastmodified DATETIME2 NOT NULL,
   externalid NVARCHAR(255),
   identity_fk BIGINT NOT NULL,
   provider NVARCHAR(8),
   issuer NVARCHAR(255) DEFAULT 'DEFAULT' NOT NULL,
   authusername NVARCHAR(255),
   credential NVARCHAR(255),
   salt NVARCHAR(255) DEFAULT NULL,
   hashalgorithm NVARCHAR(16) DEFAULT NULL,
   w_counter BIGINT DEFAULT 0,
   w_aaguid VARBINARY(16),
   w_credential_id VARBINARY(1024),
   w_user_handle VARBINARY(64),
   w_cose_key VARBINARY(1024),
   w_attestation_object NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
   w_client_extensions NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
   w_authenticator_extensions NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
   w_transports NVARCHAR(255),
   PRIMARY KEY (id),
   UNIQUE (provider, authusername)
);

-- Check and create o_bs_authentication_history table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_bs_authentication_history' AND xtype='U')
CREATE TABLE o_bs_authentication_history (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2,
   provider NVARCHAR(8),
   authusername NVARCHAR(255),
   credential NVARCHAR(255),
   salt NVARCHAR(255) DEFAULT NULL,
   hashalgorithm NVARCHAR(16) DEFAULT NULL,
   fk_identity BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_bs_recovery_key table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_bs_recovery_key' AND xtype='U')
CREATE TABLE o_bs_recovery_key (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   r_recovery_key_hash NVARCHAR(128),
   r_recovery_salt NVARCHAR(64),
   r_recovery_algorithm NVARCHAR(32),
   r_use_date DATETIME2,
   r_expiration_date DATETIME2,
   fk_identity BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_bs_webauthn_stats table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_bs_webauthn_stats' AND xtype='U')
CREATE TABLE o_bs_webauthn_stats (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   w_later_counter BIGINT NOT NULL DEFAULT 0,
   fk_identity BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_noti_pub table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_noti_pub' AND xtype='U')
CREATE TABLE o_noti_pub (
   publisher_id BIGINT NOT NULL,
   version INT NOT NULL,
   creationdate DATETIME2,
   publishertype NVARCHAR(50) NOT NULL,
   data NVARCHAR(MAX),  -- Changed LONGTEXT to NVARCHAR(MAX)
   resname NVARCHAR(50),
   resid BIGINT,
   subident NVARCHAR(128),
   businesspath NVARCHAR(255),
   state INT,
   latestnews DATETIME2 NOT NULL,
   PRIMARY KEY (publisher_id)
);

-- Check and create o_bs_identity table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_bs_identity' AND xtype='U')
CREATE TABLE o_bs_identity (
   id BIGINT NOT NULL,
   version INT NOT NULL,
   creationdate DATETIME2,
   lastlogin DATETIME2,
   name NVARCHAR(128) NOT NULL UNIQUE,
   external_id NVARCHAR(64),
   status INT,
   deleteddate DATETIME2,
   deletedroles NVARCHAR(1024),
   deletedby NVARCHAR(128),
   inactivationdate DATETIME2,
   inactivationemaildate DATETIME2,
   expirationdate DATETIME2,
   expirationemaildate DATETIME2,
   reactivationdate DATETIME2,
   deletionemaildate DATETIME2,
   PRIMARY KEY (id)
);

-- Check and create o_bs_relation_role table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_bs_relation_role' AND xtype='U')
CREATE TABLE o_bs_relation_role (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   g_role NVARCHAR(128) NOT NULL,
   g_external_id NVARCHAR(128),
   g_external_ref NVARCHAR(128),
   g_managed_flags NVARCHAR(256),
   PRIMARY KEY (id)
);

-- Check and create o_bs_relation_right table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_bs_relation_right' AND xtype='U')
CREATE TABLE o_bs_relation_right (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   g_right NVARCHAR(128) NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_bs_relation_role_to_right table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_bs_relation_role_to_right' AND xtype='U')
CREATE TABLE o_bs_relation_role_to_right (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   fk_role_id BIGINT,
   fk_right_id BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_bs_identity_to_identity table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_bs_identity_to_identity' AND xtype='U')
CREATE TABLE o_bs_identity_to_identity (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   g_external_id NVARCHAR(128),
   g_managed_flags NVARCHAR(256),
   fk_source_id BIGINT NOT NULL,
   fk_target_id BIGINT NOT NULL,
   fk_role_id BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_csp_log table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_csp_log' AND xtype='U')
CREATE TABLE o_csp_log (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2,
   l_blocked_uri NVARCHAR(1024),
   l_disposition NVARCHAR(32),
   l_document_uri NVARCHAR(1024),
   l_effective_directive NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
   l_original_policy NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
   l_referrer NVARCHAR(1024),
   l_script_sample NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
   l_status_code NVARCHAR(1024),
   l_violated_directive NVARCHAR(1024),
   l_source_file NVARCHAR(1024),
   l_line_number BIGINT,
   l_column_number BIGINT,
   fk_identity BIGINT,
   PRIMARY KEY (id)
);

-- Check and create o_olatresource table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_olatresource' AND xtype='U')
CREATE TABLE o_olatresource (
   resource_id BIGINT NOT NULL,
   version INT NOT NULL,
   creationdate DATETIME2,
   resname NVARCHAR(50) NOT NULL,
   resid BIGINT NOT NULL,
   PRIMARY KEY (resource_id),
   UNIQUE (resname, resid)
);

-- Check and create o_bs_namedgroup table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_bs_namedgroup' AND xtype='U')
CREATE TABLE o_bs_namedgroup (
   id BIGINT NOT NULL,
   version INT NOT NULL,
   creationdate DATETIME2,
   secgroup_id BIGINT NOT NULL,
   groupname NVARCHAR(16),
   PRIMARY KEY (id),
   UNIQUE (groupname)
);

-- thrid round
-- Check and create o_catentry table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_catentry' AND xtype='U')
CREATE TABLE o_catentry (
   id BIGINT NOT NULL,
   version INT NOT NULL,
   creationdate DATETIME2,
   name NVARCHAR(110) NOT NULL,
   description NVARCHAR(MAX),  -- Changed LONGTEXT to NVARCHAR(MAX)
   style NVARCHAR(16),
   externalurl NVARCHAR(255),
   fk_repoentry BIGINT,
   fk_ownergroup BIGINT UNIQUE,
   type INT NOT NULL,
   parent_id BIGINT,
   order_index BIGINT, 
   short_title NVARCHAR(255),
   add_entry_position INT,
   add_category_position INT,
   PRIMARY KEY (id)
);

-- Check and create o_note table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_note' AND xtype='U')
CREATE TABLE o_note (
   note_id BIGINT NOT NULL,
   version INT NOT NULL,
   lastmodified DATETIME2,
   creationdate DATETIME2,
   owner_id BIGINT,
   resourcetypename NVARCHAR(50) NOT NULL,
   resourcetypeid BIGINT NOT NULL,
   sub_type NVARCHAR(50),
   notetitle NVARCHAR(255),
   notetext NVARCHAR(MAX),  -- Changed LONGTEXT to NVARCHAR(MAX)
   PRIMARY KEY (note_id)
);

-- Check and create o_references table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_references' AND xtype='U')
CREATE TABLE o_references (
   reference_id BIGINT NOT NULL,
   version INT NOT NULL,
   creationdate DATETIME2,
   source_id BIGINT NOT NULL,
   target_id BIGINT NOT NULL,
   userdata NVARCHAR(64),
   PRIMARY KEY (reference_id)
);

-- Check and create o_user table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_user' AND xtype='U')
CREATE TABLE o_user (
   user_id BIGINT NOT NULL,
   version INT NOT NULL,
   creationdate DATETIME2,
   language NVARCHAR(30),
   fontsize NVARCHAR(10),
   notification_interval NVARCHAR(16),
   presencemessagespublic BIT,
   informsessiontimeout BIT NOT NULL,
   receiverealmail NVARCHAR(16),
   u_firstname NVARCHAR(255),
   u_lastname NVARCHAR(255),
   u_email NVARCHAR(255),
   u_emailsignature NVARCHAR(2048),
   u_nickname NVARCHAR(255),
   u_birthday NVARCHAR(255),
   u_graduation NVARCHAR(255),
   u_gender NVARCHAR(255),
   u_telprivate NVARCHAR(255),
   u_telmobile NVARCHAR(255),
   u_teloffice NVARCHAR(255),
   u_smstelmobile NVARCHAR(255),
   u_skype NVARCHAR(255),
   u_msn NVARCHAR(255),
   u_xing NVARCHAR(255),
   u_linkedin NVARCHAR(255),  -- Changed TEXT(255) to NVARCHAR(255)
   u_icq NVARCHAR(255),
   u_homepage NVARCHAR(255),
   u_street NVARCHAR(255),
   u_extendedaddress NVARCHAR(255),
   u_pobox NVARCHAR(255),
   u_zipcode NVARCHAR(255),
   u_region NVARCHAR(255),
   u_city NVARCHAR(255),
   u_country NVARCHAR(255),
   u_countrycode NVARCHAR(255),
   u_institutionalname NVARCHAR(255),
   u_institutionaluseridentifier NVARCHAR(255),
   u_institutionalemail NVARCHAR(255),
   u_orgunit NVARCHAR(255),
   u_studysubject NVARCHAR(255),
   u_emchangekey NVARCHAR(255),
   u_emaildisabled NVARCHAR(255),
   u_typeofuser NVARCHAR(255),
   u_socialsecuritynumber NVARCHAR(255),
   u_rank NVARCHAR(255),
   u_degree NVARCHAR(255),
   u_position NVARCHAR(255),
   u_userinterests NVARCHAR(255),
   u_usersearchedinterests NVARCHAR(255),
   u_officestreet NVARCHAR(255),
   u_extendedofficeaddress NVARCHAR(255),
   u_officepobox NVARCHAR(255),
   u_officezipcode NVARCHAR(255),
   u_officecity NVARCHAR(255),
   u_officecountry NVARCHAR(255),
   u_officemobilephone NVARCHAR(255),
   u_department NVARCHAR(255),
   u_privateemail NVARCHAR(255),
   u_employeenumber NVARCHAR(255),  -- Changed TEXT(255) to NVARCHAR(255)
   u_organizationalunit NVARCHAR(255),  -- Changed TEXT(255) to NVARCHAR(255)
   u_edupersonaffiliation NVARCHAR(255),  -- Changed TEXT(255) to NVARCHAR(255)
   u_swissedupersonstaffcategory NVARCHAR(255),  -- Changed TEXT(255) to NVARCHAR(255)
   u_swissedupersonhomeorg NVARCHAR(255),  -- Changed TEXT(255) to NVARCHAR(255)
   u_swissedupersonstudylevel NVARCHAR(255),  -- Changed TEXT(255) to NVARCHAR(255)
   u_swissedupersonhomeorgtype NVARCHAR(255),  -- Changed TEXT(255) to NVARCHAR(255)
   u_swissedupersonstudybranch1 NVARCHAR(255),  -- Changed TEXT(255) to NVARCHAR(255)
   u_swissedupersonstudybranch2 NVARCHAR(255),  -- Changed TEXT(255) to NVARCHAR(255)
   u_swissedupersonstudybranch3 NVARCHAR(255),  -- Changed TEXT(255) to NVARCHAR(255)
   u_genericselectionproperty NVARCHAR(255),
   u_genericselectionproperty2 NVARCHAR(255),
   u_genericselectionproperty3 NVARCHAR(255),
   u_generictextproperty NVARCHAR(255),
   u_generictextproperty2 NVARCHAR(255),
   u_generictextproperty3 NVARCHAR(255),
   u_generictextproperty4 NVARCHAR(255),
   u_generictextproperty5 NVARCHAR(255),
   u_genericuniquetextproperty NVARCHAR(255),
   u_genericuniquetextproperty2 NVARCHAR(255),
   u_genericuniquetextproperty3 NVARCHAR(255),
   u_genericemailproperty1 NVARCHAR(255),
   u_genericcheckboxproperty BIT,
   u_genericcheckboxproperty2 BIT,
   u_genericcheckboxproperty3 BIT,
   fk_identity BIGINT,
   PRIMARY KEY (user_id)
);

-- Check and create o_userproperty table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_userproperty' AND xtype='U')
CREATE TABLE o_userproperty (
   fk_user_id BIGINT NOT NULL,
   propname NVARCHAR(255) NOT NULL,
   propvalue NVARCHAR(255),
   PRIMARY KEY (fk_user_id, propname)
);

-- Check and create o_user_data_export table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_user_data_export' AND xtype='U')
CREATE TABLE o_user_data_export (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2,
   lastmodified DATETIME2,
   u_directory NVARCHAR(255),
   u_status NVARCHAR(16),
   u_export_ids NVARCHAR(2000),
   fk_identity BIGINT NOT NULL,
   fk_request_by BIGINT,
   PRIMARY KEY (id)
);

-- Check and create o_user_data_delete table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_user_data_delete' AND xtype='U')
CREATE TABLE o_user_data_delete (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2,
   lastmodified DATETIME2,
   u_user_data NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
   u_resource_ids NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
   u_current_resource_id NVARCHAR(64),
   PRIMARY KEY (id)
);

-- Check and create o_user_absence_leave table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_user_absence_leave' AND xtype='U')
CREATE TABLE o_user_absence_leave (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   u_absent_from DATETIME2,
   u_absent_to DATETIME2,
   u_resname NVARCHAR(50),
   u_resid BIGINT,
   u_sub_ident NVARCHAR(2048),
   fk_identity BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_message table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_message' AND xtype='U')
CREATE TABLE o_message (
   message_id BIGINT NOT NULL,
   version INT NOT NULL,
   lastmodified DATETIME2,
   creationdate DATETIME2,
   title NVARCHAR(100),
   body NVARCHAR(MAX),  -- Changed LONGTEXT to NVARCHAR(MAX)
   pseudonym NVARCHAR(255),
   guest BIT DEFAULT 0,
   parent_id BIGINT,
   topthread_id BIGINT,
   creator_id BIGINT,
   modifier_id BIGINT,
   modification_date DATETIME2,
   forum_fk BIGINT,
   statuscode INT,
   numofwords INT,
   numofcharacters INT,
   PRIMARY KEY (message_id)
);

-- Check and create o_gp_bgtoarea_rel table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_gp_bgtoarea_rel' AND xtype='U')
CREATE TABLE o_gp_bgtoarea_rel (
   bgtoarea_id BIGINT NOT NULL,
   version INT NOT NULL,
   creationdate DATETIME2,
   group_fk BIGINT NOT NULL,
   area_fk BIGINT NOT NULL,
   PRIMARY KEY (bgtoarea_id),
   UNIQUE (group_fk, area_fk)
);

-- Check and create o_noti_sub table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_noti_sub' AND xtype='U')
CREATE TABLE o_noti_sub (
   publisher_id BIGINT NOT NULL,
   version INT NOT NULL,
   lastmodified DATETIME2,
   creationdate DATETIME2,
   fk_publisher BIGINT NOT NULL,
   fk_identity BIGINT NOT NULL,
   latestemailed DATETIME2,
   subenabled BIT DEFAULT 1,
   PRIMARY KEY (publisher_id),
   UNIQUE (fk_publisher, fk_identity)
);

-- Check and create o_bs_policy table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_bs_policy' AND xtype='U')
CREATE TABLE o_bs_policy (
   id BIGINT NOT NULL,
   version INT NOT NULL,
   creationdate DATETIME2,
   oresource_id BIGINT NOT NULL,
   group_id BIGINT NOT NULL,
   permission NVARCHAR(16) NOT NULL,
   apply_from DATETIME2 DEFAULT NULL,
   apply_to DATETIME2 DEFAULT NULL,
   PRIMARY KEY (id),
   UNIQUE (oresource_id, group_id, permission)
);

-- Check and create o_gp_bgarea table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_gp_bgarea' AND xtype='U')
CREATE TABLE o_gp_bgarea (
   area_id BIGINT NOT NULL,
   version INT NOT NULL,
   creationdate DATETIME2,
   name NVARCHAR(255) NOT NULL,
   descr NVARCHAR(MAX),  -- Changed LONGTEXT to NVARCHAR(MAX)
   fk_resource BIGINT DEFAULT NULL,
   PRIMARY KEY (area_id)
);

-- Check and create o_repositoryentry table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_repositoryentry' AND xtype='U')
CREATE TABLE o_repositoryentry (
   repositoryentry_id BIGINT NOT NULL,
   version INT NOT NULL,
   lastmodified DATETIME2,
   creationdate DATETIME2,
   softkey NVARCHAR(36) NOT NULL UNIQUE,
   external_id NVARCHAR(64),
   external_ref NVARCHAR(255),
   managed_flags NVARCHAR(255),
   technical_type NVARCHAR(128),
   runtime_type NVARCHAR(16),
   displayname NVARCHAR(110) NOT NULL,
   resourcename NVARCHAR(100) NOT NULL,
   authors NVARCHAR(2048),
   mainlanguage NVARCHAR(255),
   location NVARCHAR(255),
   objectives NVARCHAR(MAX),  -- Changed from NVARCHAR(32000) to NVARCHAR(MAX)
   requirements NVARCHAR(MAX),  -- Changed from NVARCHAR(32000) to NVARCHAR(MAX)
   credits NVARCHAR(MAX),  -- Changed from NVARCHAR(32000) to NVARCHAR(MAX)
   expenditureofwork NVARCHAR(MAX),  -- Changed from NVARCHAR(32000) to NVARCHAR(MAX)
   fk_stats BIGINT NOT NULL UNIQUE,
   fk_lifecycle BIGINT,
   fk_olatresource BIGINT UNIQUE,
   description NVARCHAR(MAX),  -- Changed LONGTEXT to NVARCHAR(MAX)
   teaser NVARCHAR(255),
   initialauthor NVARCHAR(128) NOT NULL,
   status NVARCHAR(16) DEFAULT 'preparation' NOT NULL,
   status_published_date DATETIME2,
   allusers BIT DEFAULT 0 NOT NULL,
   guests BIT DEFAULT 0 NOT NULL,
   bookable BIT DEFAULT 0 NOT NULL,
   publicvisible BIT DEFAULT 0 NOT NULL,  -- Changed BOOL to BIT
   videocollection BIT DEFAULT 0 NOT NULL,  -- Changed BOOL to BIT
   allowtoleave NVARCHAR(16),
   candownload BIT NOT NULL,
   cancopy BIT NOT NULL,
   canreference BIT NOT NULL,
   canindexmetadata BIT NOT NULL,
   invitations_owner_enabled BIT DEFAULT 0 NOT NULL,  -- Changed BOOL to BIT
   lti_deployment_owner_enabled BIT DEFAULT 0 NOT NULL,  -- Changed BOOL to BIT
   deletiondate DATETIME2 DEFAULT NULL,
   fk_deleted_by BIGINT DEFAULT NULL,
   fk_educational_type BIGINT DEFAULT NULL,
   PRIMARY KEY (repositoryentry_id)
);

-- Check and create o_re_to_group table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_re_to_group' AND xtype='U')
CREATE TABLE o_re_to_group (
   id BIGINT NOT NULL,
   creationdate DATETIME2 NOT NULL,
   r_defgroup BIT NOT NULL,  -- Changed BOOLEAN to BIT
   fk_group_id BIGINT NOT NULL,
   fk_entry_id BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_re_to_tax_level table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_re_to_tax_level' AND xtype='U')
CREATE TABLE o_re_to_tax_level (
  id BIGINT NOT NULL IDENTITY(1,1),
  creationdate DATETIME2 NOT NULL,
  fk_entry BIGINT NOT NULL,
  fk_taxonomy_level BIGINT NOT NULL,
  PRIMARY KEY (id)
);

-- Check and create o_repositoryentry_cycle table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_repositoryentry_cycle' AND xtype='U')
CREATE TABLE o_repositoryentry_cycle (
   id BIGINT NOT NULL,
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   r_softkey NVARCHAR(64),
   r_label NVARCHAR(255),
   r_privatecycle BIT DEFAULT 0,  -- Changed BOOLEAN to BIT
   r_validfrom DATETIME2,
   r_validto DATETIME2,
   PRIMARY KEY (id)
);


-- Check and create o_repositoryentry_stats table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_repositoryentry_stats' AND xtype='U')
CREATE TABLE o_repositoryentry_stats (
   id BIGINT NOT NULL,
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   r_rating DECIMAL(38,30),  -- Adjusted precision to fit within the maximum allowed
   r_num_of_ratings BIGINT NOT NULL DEFAULT 0,
   r_num_of_comments BIGINT NOT NULL DEFAULT 0,
   r_launchcounter BIGINT NOT NULL DEFAULT 0,
   r_downloadcounter BIGINT NOT NULL DEFAULT 0,
   r_lastusage DATETIME2 NOT NULL,
   PRIMARY KEY (id)
);


-- Check and create o_bs_membership table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_bs_membership' AND xtype='U')
CREATE TABLE o_bs_membership (
   id BIGINT NOT NULL,
   version INT NOT NULL,
   lastmodified DATETIME2,
   creationdate DATETIME2,
   secgroup_id BIGINT NOT NULL,
   identity_id BIGINT NOT NULL,
   PRIMARY KEY (id),
   UNIQUE (secgroup_id, identity_id)
);

-- Check and create o_re_educational_type table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_re_educational_type' AND xtype='U')
CREATE TABLE o_re_educational_type (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   r_identifier NVARCHAR(128) NOT NULL,
   r_predefined BIT NOT NULL DEFAULT 0,  -- Changed BOOLEAN to BIT
   r_css_class NVARCHAR(128),
   r_preset_mycourses BIT NOT NULL DEFAULT 0,  -- Changed BOOLEAN to BIT
   PRIMARY KEY (id)
);

-- Check and create o_plock table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_plock' AND xtype='U')
CREATE TABLE o_plock (
    plock_id BIGINT NOT NULL,
    version INT NOT NULL,
    creationdate DATETIME2,
    asset NVARCHAR(255) NOT NULL UNIQUE,
    PRIMARY KEY (plock_id)
);

-- Check and create hibernate_unique_key table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='hibernate_unique_key' AND xtype='U')
CREATE TABLE hibernate_unique_key (
    next_hi INT
);

-- Check and create o_lifecycle table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_lifecycle' AND xtype='U')
CREATE TABLE o_lifecycle (
   id BIGINT NOT NULL,
   version INT NOT NULL,
   creationdate DATETIME2,
   persistenttypename NVARCHAR(50) NOT NULL,
   persistentref BIGINT NOT NULL,
   action NVARCHAR(50) NOT NULL,
   lctimestamp DATETIME2,
   uservalue NVARCHAR(MAX),  -- Changed LONGTEXT to NVARCHAR(MAX)
   PRIMARY KEY (id)
);

-- Check and create oc_lock table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='oc_lock' AND xtype='U')
CREATE TABLE oc_lock (
    lock_id BIGINT NOT NULL,
    version INT NOT NULL,
    creationdate DATETIME2,
    identity_fk BIGINT NOT NULL,
    asset NVARCHAR(120) NOT NULL UNIQUE,
    windowid NVARCHAR(32) DEFAULT NULL,
    PRIMARY KEY (lock_id)
);

-- Check and create o_readmessage table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_readmessage' AND xtype='U')
CREATE TABLE o_readmessage (
    id BIGINT NOT NULL,
    version INT NOT NULL,
    creationdate DATETIME2,
    identity_id BIGINT NOT NULL,
    forum_id BIGINT NOT NULL,
    message_id BIGINT NOT NULL,
    PRIMARY KEY (id)
);

-- Check and create o_loggingtable table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_loggingtable' AND xtype='U')
CREATE TABLE o_loggingtable (
    log_id BIGINT NOT NULL,
    creationdate DATETIME2,
    sourceclass NVARCHAR(255),
    sessionid NVARCHAR(255) NOT NULL,
    user_id BIGINT,
    actioncrudtype NVARCHAR(1) NOT NULL,
    actionverb NVARCHAR(16) NOT NULL,
    actionobject NVARCHAR(32) NOT NULL,
    simpleduration BIGINT NOT NULL,
    resourceadminaction BIT NOT NULL,  -- Changed BOOLEAN to BIT
    businesspath NVARCHAR(2048),
    greatgrandparentrestype NVARCHAR(32),
    greatgrandparentresid NVARCHAR(64),
    greatgrandparentresname NVARCHAR(255),
    grandparentrestype NVARCHAR(32),
    grandparentresid NVARCHAR(64),
    grandparentresname NVARCHAR(255),
    parentrestype NVARCHAR(32),
    parentresid NVARCHAR(64),
    parentresname NVARCHAR(255),
    targetrestype NVARCHAR(32),
    targetresid NVARCHAR(64),
    targetresname NVARCHAR(255),
    PRIMARY KEY (log_id)
);

-- Check and create o_checklist table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_checklist' AND xtype='U')
CREATE TABLE o_checklist (
   checklist_id BIGINT NOT NULL,
   version INT NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   title NVARCHAR(255),
   description NVARCHAR(MAX),  -- Changed LONGTEXT to NVARCHAR(MAX)
   PRIMARY KEY (checklist_id)
);

-- Check and create o_checkpoint table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_checkpoint' AND xtype='U')
CREATE TABLE o_checkpoint (
   checkpoint_id BIGINT NOT NULL,
   version INT NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   title NVARCHAR(255),
   description NVARCHAR(MAX),  -- Changed LONGTEXT to NVARCHAR(MAX)
   modestring NVARCHAR(64) NOT NULL,
   checklist_fk BIGINT,
   PRIMARY KEY (checkpoint_id)
);

-- Check and create o_checkpoint_results table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_checkpoint_results' AND xtype='U')
CREATE TABLE o_checkpoint_results (
   checkpoint_result_id BIGINT NOT NULL,
   version INT NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   result BIT NOT NULL,  -- Changed BOOLEAN to BIT
   checkpoint_fk BIGINT,
   identity_fk BIGINT,
   PRIMARY KEY (checkpoint_result_id)
);

-- Check and create o_projectbroker table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_projectbroker' AND xtype='U')
CREATE TABLE o_projectbroker (
   projectbroker_id BIGINT NOT NULL,
   version INT NOT NULL,
   creationdate DATETIME2,
   PRIMARY KEY (projectbroker_id)
);

-- Check and create o_projectbroker_project table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_projectbroker_project' AND xtype='U')
CREATE TABLE o_projectbroker_project (
   project_id BIGINT NOT NULL,
   version INT NOT NULL,
   creationdate DATETIME2,
   title NVARCHAR(150),
   description NVARCHAR(MAX),  -- Changed LONGTEXT to NVARCHAR(MAX)
   state NVARCHAR(20),
   maxMembers INT,
   attachmentFileName NVARCHAR(100),
   mailNotificationEnabled BIT NOT NULL,  -- Changed BOOLEAN to BIT
   projectgroup_fk BIGINT NOT NULL,
   projectbroker_fk BIGINT NOT NULL,
   candidategroup_fk BIGINT NOT NULL,
   PRIMARY KEY (project_id)
);

-- Check and create o_projectbroker_customfields table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_projectbroker_customfields' AND xtype='U')
CREATE TABLE o_projectbroker_customfields (
   fk_project_id BIGINT NOT NULL,
   propname NVARCHAR(255) NOT NULL,
   propvalue NVARCHAR(255),
   PRIMARY KEY (fk_project_id, propname)
);

-- Check and create o_usercomment table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_usercomment' AND xtype='U')
CREATE TABLE o_usercomment (
    comment_id BIGINT NOT NULL,
    version INT NOT NULL,
    creationdate DATETIME2,
    resname NVARCHAR(50) NOT NULL,
    resid BIGINT NOT NULL,
    ressubpath NVARCHAR(2048),
    creator_id BIGINT NOT NULL,
    commenttext NVARCHAR(MAX),  -- Changed LONGTEXT to NVARCHAR(MAX)
    parent_key BIGINT,
    PRIMARY KEY (comment_id)
);

-- Check and create o_userrating table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_userrating' AND xtype='U')
CREATE TABLE o_userrating (
    rating_id BIGINT NOT NULL,
    version INT NOT NULL,
    creationdate DATETIME2,
    lastmodified DATETIME2,
    resname NVARCHAR(50) NOT NULL,
    resid BIGINT NOT NULL,
    ressubpath NVARCHAR(2048),
    creator_id BIGINT NOT NULL,
    rating INT NOT NULL,
    PRIMARY KEY (rating_id)
);

-- Check and create o_co_db_entry table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_co_db_entry' AND xtype='U')
CREATE TABLE o_co_db_entry (
   id BIGINT NOT NULL,
   version BIGINT NOT NULL,
   lastmodified DATETIME2,
   creationdate DATETIME2,
   courseid BIGINT,
   idprofile BIGINT,  -- Changed from identity to idprofile to avoid reserved word conflict
   category NVARCHAR(32),
   name NVARCHAR(255) NOT NULL,
   floatvalue DECIMAL(38,30),
   longvalue BIGINT,
   stringvalue NVARCHAR(255),
   textvalue NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
   PRIMARY KEY (id)
);

-- Check and create o_stat_lastupdated table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_stat_lastupdated' AND xtype='U')
CREATE TABLE o_stat_lastupdated (
    lastupdated DATETIME2 NOT NULL
);
-- important: initialize with old date!
INSERT INTO o_stat_lastupdated VALUES(CAST('1999-01-01' AS DATETIME2));

-- Check and create o_stat_dayofweek table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_stat_dayofweek' AND xtype='U')
CREATE TABLE o_stat_dayofweek (
    id BIGINT NOT NULL IDENTITY(1,1),
    businesspath NVARCHAR(2048) NOT NULL,
    resid BIGINT NOT NULL,
    day INT NOT NULL,
    value INT NOT NULL,
    PRIMARY KEY (id)
);
CREATE INDEX statdow_resid_idx ON o_stat_dayofweek (resid);

-- Check and create o_stat_hourofday table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_stat_hourofday' AND xtype='U')
CREATE TABLE o_stat_hourofday (
    id BIGINT NOT NULL IDENTITY(1,1),
    businesspath NVARCHAR(2048) NOT NULL,
    resid BIGINT NOT NULL,
    hour INT NOT NULL,
    value INT NOT NULL,
    PRIMARY KEY (id)
);
CREATE INDEX stathod_resid_idx ON o_stat_hourofday (resid);

-- Check and create o_stat_weekly table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_stat_weekly' AND xtype='U')
CREATE TABLE o_stat_weekly (
    id BIGINT NOT NULL IDENTITY(1,1),
    businesspath NVARCHAR(2048) NOT NULL,
    resid BIGINT NOT NULL,
    week NVARCHAR(7) NOT NULL,
    value INT NOT NULL,
    PRIMARY KEY (id)
);
CREATE INDEX statwee_resid_idx ON o_stat_weekly (resid);

-- Check and create o_stat_daily table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_stat_daily' AND xtype='U')
CREATE TABLE o_stat_daily (
    id BIGINT NOT NULL IDENTITY(1,1),
    businesspath NVARCHAR(2048) NOT NULL,
    resid BIGINT NOT NULL,
    day DATETIME2 NOT NULL,
    value INT NOT NULL,
    PRIMARY KEY (id)
);
CREATE INDEX statday_resid_idx ON o_stat_daily (resid);

-- Check and create o_mark table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_mark' AND xtype='U')
CREATE TABLE o_mark (
  mark_id BIGINT NOT NULL,
  version INT NOT NULL,
  creationdate DATETIME2,
  resname NVARCHAR(50) NOT NULL,
  resid BIGINT NOT NULL,
  ressubpath NVARCHAR(2048),
  businesspath NVARCHAR(2048),
  creator_id BIGINT NOT NULL,
  PRIMARY KEY (mark_id)
);

-- Check and create o_info_message table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_info_message' AND xtype='U')
CREATE TABLE o_info_message (
  info_id BIGINT  NOT NULL,
  version INT NOT NULL,
  creationdate DATETIME2,
  modificationdate DATETIME2,
  title NVARCHAR(2048),
  message NVARCHAR(MAX),  -- Changed LONGTEXT to NVARCHAR(MAX)
  attachmentpath NVARCHAR(1024),
  resname NVARCHAR(50) NOT NULL,
  resid BIGINT NOT NULL,
  ressubpath NVARCHAR(2048),
  businesspath NVARCHAR(2048),
  publishdate DATETIME2 DEFAULT NULL,
  published BIT NOT NULL DEFAULT 0,  -- Changed BOOLEAN to BIT
  sendmailto NVARCHAR(255),
  fk_author_id BIGINT,
  fk_modifier_id BIGINT,
  PRIMARY KEY (info_id)
);

-- Check and create o_info_message_to_group table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_info_message_to_group' AND xtype='U')
CREATE TABLE o_info_message_to_group (
   id BIGINT NOT NULL IDENTITY(1,1),
   fk_info_message_id BIGINT NOT NULL,
   fk_group_id BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_info_message_to_cur_el table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_info_message_to_cur_el' AND xtype='U')
CREATE TABLE o_info_message_to_cur_el (
   id BIGINT NOT NULL IDENTITY(1,1),
   fk_info_message_id BIGINT NOT NULL,
   fk_cur_element_id BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_bs_invitation table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_bs_invitation' AND xtype='U')
CREATE TABLE o_bs_invitation (
   id BIGINT NOT NULL,
   creationdate DATETIME2,
   token NVARCHAR(64) NOT NULL,
   first_name NVARCHAR(64),
   last_name NVARCHAR(64),
   mail NVARCHAR(128),
   i_type NVARCHAR(32) DEFAULT 'binder' NOT NULL,
   i_status NVARCHAR(32) DEFAULT 'active',
   i_url NVARCHAR(512),
   i_roles NVARCHAR(255),
   i_registration BIT DEFAULT 0 NOT NULL,  -- Changed BOOLEAN to BIT
   i_additional_infos NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
   fk_group_id BIGINT,
   fk_identity_id BIGINT,
   PRIMARY KEY (id)
);

-- Check and create o_tag_tag table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_tag_tag' AND xtype='U')
CREATE TABLE o_tag_tag (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2,
   t_display_name NVARCHAR(256) NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_todo_task table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_todo_task' AND xtype='U')
CREATE TABLE o_todo_task (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   t_content_modified_date DATETIME2 NOT NULL,
   t_title NVARCHAR(128),
   t_description NVARCHAR(MAX),  -- Changed LONGTEXT to NVARCHAR(MAX)
   t_status NVARCHAR(16),
   t_priority NVARCHAR(16),
   t_expenditure_of_work INT,
   t_start_date DATETIME2,
   t_due_date DATETIME2,
   t_done_date DATETIME2,
   t_type NVARCHAR(50),
   t_deleted_date DATETIME2,
   fk_deleted_by BIGINT,
   t_assignee_rights NVARCHAR(255),
   t_origin_id BIGINT,
   t_origin_subpath NVARCHAR(100),
   t_origin_title NVARCHAR(500),
   t_origin_sub_title NVARCHAR(500),
   t_origin_deleted BIT DEFAULT 0 NOT NULL,  -- Changed BOOLEAN to BIT
   t_origin_deleted_date DATETIME2,
   fk_origin_deleted_by BIGINT,
   fk_group BIGINT NOT NULL,
   fk_collection BIGINT,
   PRIMARY KEY (id)
);

-- Check and create o_todo_task_tag table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_todo_task_tag' AND xtype='U')
CREATE TABLE o_todo_task_tag (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   fk_todo_task BIGINT NOT NULL,
   fk_tag BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_mail table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_mail' AND xtype='U')
CREATE TABLE o_mail (
  mail_id BIGINT NOT NULL,
  meta_mail_id NVARCHAR(64),
  creationdate DATETIME2,
  lastmodified DATETIME2,
  resname NVARCHAR(50),
  resid BIGINT,
  ressubpath NVARCHAR(2048),
  businesspath NVARCHAR(2048),
  subject NVARCHAR(512),
  body NVARCHAR(MAX),  -- Changed LONGTEXT to NVARCHAR(MAX)
  fk_from_id BIGINT,
  PRIMARY KEY (mail_id)
);

-- Check and create o_mail_to_recipient table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_mail_to_recipient' AND xtype='U')
CREATE TABLE o_mail_to_recipient (
  pos INT NOT NULL DEFAULT 0,  -- Changed MEDIUMINT to INT
  fk_mail_id BIGINT,
  fk_recipient_id BIGINT
);

-- Check and create o_mail_recipient table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_mail_recipient' AND xtype='U')
CREATE TABLE o_mail_recipient (
  recipient_id BIGINT NOT NULL,
  recipientvisible BIT,
  deleted BIT,
  mailread BIT,
  mailmarked BIT,
  email NVARCHAR(255),
  recipientgroup NVARCHAR(255),
  creationdate DATETIME2,
  fk_recipient_id BIGINT,
  PRIMARY KEY (recipient_id)
);

-- Check and create o_mail_attachment table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_mail_attachment' AND xtype='U')
CREATE TABLE o_mail_attachment (
   attachment_id BIGINT NOT NULL,
   creationdate DATETIME2,
   datas VARBINARY(MAX),  -- Changed MEDIUMBLOB to VARBINARY(MAX)
   datas_size BIGINT,
   datas_name NVARCHAR(255),
   datas_checksum BIGINT,
   datas_path NVARCHAR(1024),
   datas_lastmodified DATETIME2,
   mimetype NVARCHAR(255),
   fk_att_mail_id BIGINT,
   PRIMARY KEY (attachment_id)
);

-- Check and create o_ac_offer table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_ac_offer' AND xtype='U')
CREATE TABLE o_ac_offer (
  offer_id BIGINT NOT NULL,
  creationdate DATETIME2,
  lastmodified DATETIME2,
  is_valid BIT DEFAULT 1,
  validfrom DATETIME2,
  validto DATETIME2,
  version INT NOT NULL,
  resourceid BIGINT,
  resourcetypename NVARCHAR(255),
  resourcedisplayname NVARCHAR(255),
  autobooking BIT DEFAULT 0,  -- Changed BOOLEAN to BIT
  confirmation_email BIT DEFAULT 0,
  open_access BIT DEFAULT 0 NOT NULL,  -- Changed BOOLEAN to BIT
  guest_access BIT DEFAULT 0 NOT NULL,  -- Changed BOOLEAN to BIT
  catalog_publish BIT DEFAULT 0 NOT NULL,  -- Changed BOOLEAN to BIT
  catalog_web_publish BIT DEFAULT 0 NOT NULL,  -- Changed BOOLEAN to BIT
  token NVARCHAR(255),
  price_amount DECIMAL(12,4),
  price_currency_code NVARCHAR(3),
  offer_desc NVARCHAR(2000),
  fk_resource_id BIGINT,
  PRIMARY KEY (offer_id)
);

-- Check and create o_ac_offer_to_organisation table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_ac_offer_to_organisation' AND xtype='U')
CREATE TABLE o_ac_offer_to_organisation (
  id BIGINT NOT NULL IDENTITY(1,1),
  creationdate DATETIME2 NOT NULL,
  lastmodified DATETIME2 NOT NULL,
  fk_offer BIGINT NOT NULL,
  fk_organisation BIGINT NOT NULL,
  PRIMARY KEY (id)
);

-- Check and create o_ac_method table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_ac_method' AND xtype='U')
CREATE TABLE o_ac_method (
    method_id BIGINT NOT NULL,
    access_method NVARCHAR(32),
    version INT NOT NULL,
    creationdate DATETIME2,
    lastmodified DATETIME2,
    is_valid BIT DEFAULT 1,
    is_enabled BIT DEFAULT 1,
    validfrom DATETIME2,
    validto DATETIME2,
    PRIMARY KEY (method_id)
);


--fourth round
-- Check and create o_ac_offer_access table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_ac_offer_access' AND xtype='U')
CREATE TABLE o_ac_offer_access (
    offer_method_id BIGINT NOT NULL,
    version INT NOT NULL,  -- Changed from MEDIUMINT UNSIGNED to INT
    creationdate DATETIME2,
    is_valid BIT DEFAULT 1,
    validfrom DATETIME2,
    validto DATETIME2,
    fk_offer_id BIGINT,
    fk_method_id BIGINT,
    PRIMARY KEY (offer_method_id)
);

-- Check and create o_ac_auto_advance_order table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_ac_auto_advance_order' AND xtype='U')
CREATE TABLE o_ac_auto_advance_order (
    id BIGINT NOT NULL IDENTITY(1,1),
    creationdate DATETIME2 NOT NULL,
    lastmodified DATETIME2 NOT NULL,
    a_identifier_key NVARCHAR(64) NOT NULL,
    a_identifier_value NVARCHAR(64) NOT NULL,
    a_status NVARCHAR(32) NOT NULL,
    a_status_modified DATETIME2 NOT NULL,
    fk_identity BIGINT NOT NULL,  -- Changed from INT8 to BIGINT
    fk_method BIGINT NOT NULL,  -- Changed from INT8 to BIGINT
    PRIMARY KEY (id)
);

-- Check and create o_ac_order table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_ac_order' AND xtype='U')
CREATE TABLE o_ac_order (
    order_id BIGINT NOT NULL,
    version INT NOT NULL,  -- Changed from MEDIUMINT UNSIGNED to INT
    creationdate DATETIME2,
    lastmodified DATETIME2,
    is_valid BIT DEFAULT 1,
    total_lines_amount DECIMAL(12,4),
    total_lines_currency_code NVARCHAR(3),
    total_amount DECIMAL(12,4),
    total_currency_code NVARCHAR(3),
    discount_amount DECIMAL(12,4),
    discount_currency_code NVARCHAR(3),
    order_status NVARCHAR(32) DEFAULT 'NEW',
    fk_delivery_id BIGINT,
    PRIMARY KEY (order_id)
);

-- Check and create o_ac_order_part table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_ac_order_part' AND xtype='U')
CREATE TABLE o_ac_order_part (
    order_part_id BIGINT NOT NULL,
    version INT NOT NULL,  -- Changed from MEDIUMINT UNSIGNED to INT
    pos INT,  -- Changed from MEDIUMINT UNSIGNED to INT
    creationdate DATETIME2,
    total_lines_amount DECIMAL(12,4),
    total_lines_currency_code NVARCHAR(3),
    total_amount DECIMAL(12,4),
    total_currency_code NVARCHAR(3),
    fk_order_id BIGINT,
    PRIMARY KEY (order_part_id)
);

-- Check and create o_ac_order_line table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_ac_order_line' AND xtype='U')
CREATE TABLE o_ac_order_line (
    order_item_id BIGINT NOT NULL,
    version INT NOT NULL,  -- Changed from MEDIUMINT UNSIGNED to INT
    pos INT,  -- Changed from MEDIUMINT UNSIGNED to INT
    creationdate DATETIME2,
    unit_price_amount DECIMAL(12,4),
    unit_price_currency_code NVARCHAR(3),
    total_amount DECIMAL(12,4),
    total_currency_code NVARCHAR(3),
    fk_order_part_id BIGINT,
    fk_offer_id BIGINT,
    PRIMARY KEY (order_item_id)
);

-- Check and create o_ac_transaction table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_ac_transaction' AND xtype='U')
CREATE TABLE o_ac_transaction (
    transaction_id BIGINT NOT NULL,
    version INT NOT NULL,  -- Changed from MEDIUMINT UNSIGNED to INT
    creationdate DATETIME2,
    trx_status NVARCHAR(32) DEFAULT 'NEW',
    amount_amount DECIMAL(12,4),
    amount_currency_code NVARCHAR(3),
    fk_order_part_id BIGINT,
    fk_order_id BIGINT,
    fk_method_id BIGINT,
    PRIMARY KEY (transaction_id)
);

-- Check and create o_ac_reservation table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_ac_reservation' AND xtype='U')
CREATE TABLE o_ac_reservation (
    reservation_id BIGINT NOT NULL,
    creationdate DATETIME2,
    lastmodified DATETIME2,
    version INT NOT NULL,  -- Changed from MEDIUMINT UNSIGNED to INT
    expirationdate DATETIME2,
    reservationtype NVARCHAR(32),
    fk_identity BIGINT NOT NULL,
    fk_resource BIGINT NOT NULL,
    PRIMARY KEY (reservation_id)
);

-- Check and create o_ac_paypal_transaction table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_ac_paypal_transaction' AND xtype='U')
CREATE TABLE o_ac_paypal_transaction (
    transaction_id BIGINT NOT NULL,
    version BIGINT NOT NULL,
    creationdate DATETIME2,
    ref_no NVARCHAR(255),
    order_id BIGINT NOT NULL,
    order_part_id BIGINT NOT NULL,
    method_id BIGINT NOT NULL,
    success_uuid NVARCHAR(32) NOT NULL,
    cancel_uuid NVARCHAR(32) NOT NULL,
    amount_amount DECIMAL(12,4),
    amount_currency_code NVARCHAR(3),
    pay_response_date DATETIME2,
    pay_key NVARCHAR(255),
    ack NVARCHAR(255),
    build NVARCHAR(255),
    coorelation_id NVARCHAR(255),
    payment_exec_status NVARCHAR(255),
    ipn_transaction_id NVARCHAR(255),
    ipn_transaction_status NVARCHAR(255),
    ipn_sender_transaction_id NVARCHAR(255),
    ipn_sender_transaction_status NVARCHAR(255),
    ipn_sender_email NVARCHAR(255),
    ipn_verify_sign NVARCHAR(255),
    ipn_pending_reason NVARCHAR(255),
    trx_status NVARCHAR(32) NOT NULL DEFAULT 'NEW',
    trx_amount DECIMAL(12,4),
    trx_currency_code NVARCHAR(3),
    PRIMARY KEY (transaction_id)
);

-- Check and create o_ac_checkout_transaction table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_ac_checkout_transaction' AND xtype='U')
CREATE TABLE o_ac_checkout_transaction (
    id BIGINT NOT NULL IDENTITY(1,1),
    creationdate DATETIME2 NOT NULL,
    lastmodified DATETIME2 NOT NULL,
    p_success_uuid NVARCHAR(64) NOT NULL,
    p_cancel_uuid NVARCHAR(64) NOT NULL,
    p_order_nr NVARCHAR(64) NOT NULL,
    p_order_id BIGINT NOT NULL,
    p_order_part_id BIGINT NOT NULL,
    p_method_id BIGINT NOT NULL,
    p_amount_currency_code NVARCHAR(3) NOT NULL,
    p_amount_amount DECIMAL(12,4) NOT NULL,
    p_status NVARCHAR(32) NOT NULL,
    p_paypal_order_id NVARCHAR(64),
    p_paypal_order_status NVARCHAR(64),
    p_paypal_order_status_reason NVARCHAR(MAX),
    p_paypal_authorization_id NVARCHAR(64),
    p_paypal_capture_id NVARCHAR(64),
    p_capture_currency_code NVARCHAR(3),
    p_capture_amount DECIMAL(12,4),
    p_paypal_invoice_id NVARCHAR(64),
    PRIMARY KEY (id)
);

-- Check and create o_ca_launcher table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_ca_launcher' AND xtype='U')
CREATE TABLE o_ca_launcher (
    id BIGINT NOT NULL IDENTITY(1,1),
    lastmodified DATETIME2 NOT NULL,
    creationdate DATETIME2 NOT NULL,
    c_type NVARCHAR(50),
    c_identifier NVARCHAR(32),
    c_sort_order INT,
    c_enabled BIT NOT NULL DEFAULT 1,  -- Changed BOOL to BIT
    c_config NVARCHAR(4000),
    PRIMARY KEY (id)
);

-- Check and create o_ca_launcher_to_organisation table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_ca_launcher_to_organisation' AND xtype='U')
CREATE TABLE o_ca_launcher_to_organisation (
    id BIGINT NOT NULL IDENTITY(1,1),
    creationdate DATETIME2 NOT NULL,
    lastmodified DATETIME2 NOT NULL,
    fk_launcher BIGINT NOT NULL,
    fk_organisation BIGINT NOT NULL,
    PRIMARY KEY (id)
);

-- Check and create o_ca_filter table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_ca_filter' AND xtype='U')
CREATE TABLE o_ca_filter (
    id BIGINT NOT NULL IDENTITY(1,1),
    lastmodified DATETIME2 NOT NULL,
    creationdate DATETIME2 NOT NULL,
    c_type NVARCHAR(50),
    c_sort_order INT,
    c_enabled BIT NOT NULL DEFAULT 1,  -- Changed BOOL to BIT
    c_default_visible BIT NOT NULL DEFAULT 1,  -- Changed BOOL to BIT
    c_config NVARCHAR(4000),
    PRIMARY KEY (id)
);

-- Check and create o_om_room_reference table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_om_room_reference' AND xtype='U')
CREATE TABLE o_om_room_reference (
    id BIGINT NOT NULL,
    version INT NOT NULL,  -- Changed from MEDIUMINT UNSIGNED to INT
    lastmodified DATETIME2,
    creationdate DATETIME2,
    businessgroup BIGINT,
    resourcetypename NVARCHAR(50),
    resourcetypeid BIGINT,
    ressubpath NVARCHAR(255),
    roomId BIGINT,
    config NVARCHAR(MAX),  -- Changed LONGTEXT to NVARCHAR(MAX)
    PRIMARY KEY (id)
);

-- Check and create o_aconnect_meeting table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_aconnect_meeting' AND xtype='U')
CREATE TABLE o_aconnect_meeting (
    id BIGINT NOT NULL IDENTITY(1,1),
    creationdate DATETIME2 NOT NULL,
    lastmodified DATETIME2 NOT NULL,
    a_sco_id NVARCHAR(128) DEFAULT NULL,
    a_folder_id NVARCHAR(128) DEFAULT NULL,
    a_env_name NVARCHAR(128) DEFAULT NULL,
    a_name NVARCHAR(128) NOT NULL,
    a_description NVARCHAR(2000) DEFAULT NULL,
    a_permanent BIT DEFAULT 0 NOT NULL,  -- Changed BOOL to BIT
    a_start_date DATETIME2 DEFAULT NULL,
    a_leadtime BIGINT DEFAULT 0 NOT NULL,
    a_start_with_leadtime DATETIME2,
    a_end_date DATETIME2 DEFAULT NULL,
    a_followuptime BIGINT DEFAULT 0 NOT NULL,
    a_end_with_followuptime DATETIME2,
    a_opened BIT DEFAULT 0 NOT NULL,  -- Changed BOOL to BIT
    a_template_id NVARCHAR(32) DEFAULT NULL,
    a_shared_documents NVARCHAR(2000) DEFAULT NULL,
    fk_entry_id BIGINT DEFAULT NULL,
    a_sub_ident NVARCHAR(64) DEFAULT NULL,
    fk_group_id BIGINT DEFAULT NULL,
    PRIMARY KEY (id)
);

-- Check and create o_aconnect_user table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_aconnect_user' AND xtype='U')
CREATE TABLE o_aconnect_user (
    id BIGINT NOT NULL IDENTITY(1,1),
    creationdate DATETIME2 NOT NULL,
    lastmodified DATETIME2 NOT NULL,
    a_principal_id NVARCHAR(128) DEFAULT NULL,
    a_env_name NVARCHAR(128) DEFAULT NULL,
    fk_identity_id BIGINT DEFAULT NULL,
    PRIMARY KEY (id)
);

-- Check and create o_bbb_template table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_bbb_template' AND xtype='U')
CREATE TABLE o_bbb_template (
    id BIGINT NOT NULL IDENTITY(1,1),
    creationdate DATETIME2 NOT NULL,
    lastmodified DATETIME2 NOT NULL,
    b_name NVARCHAR(128) NOT NULL,
    b_description NVARCHAR(2000) DEFAULT NULL,
    b_system BIT DEFAULT 0 NOT NULL,  -- Changed BOOL to BIT
    b_enabled BIT DEFAULT 1 NOT NULL,  -- Changed BOOL to BIT
    b_external_id NVARCHAR(255) DEFAULT NULL,
    b_external_users BIT DEFAULT 1 NOT NULL,  -- Changed BOOL to BIT
    b_max_concurrent_meetings INT DEFAULT NULL,
    b_max_participants INT DEFAULT NULL,
    b_max_duration BIGINT DEFAULT NULL,
    b_record BIT DEFAULT NULL,  -- Changed BOOL to BIT
    b_breakout BIT DEFAULT NULL,  -- Changed BOOL to BIT
    b_mute_on_start BIT DEFAULT NULL,  -- Changed BOOL to BIT
    b_auto_start_recording BIT DEFAULT NULL,  -- Changed BOOL to BIT
    b_allow_start_stop_recording BIT DEFAULT NULL,  -- Changed BOOL to BIT
    b_webcams_only_for_moderator BIT DEFAULT NULL,  -- Changed BOOL to BIT
    b_allow_mods_to_unmute_users BIT DEFAULT NULL,  -- Changed BOOL to BIT
    b_lock_set_disable_cam BIT DEFAULT NULL,  -- Changed BOOL to BIT
    b_lock_set_disable_mic BIT DEFAULT NULL,  -- Changed BOOL to BIT
    b_lock_set_disable_priv_chat BIT DEFAULT NULL,  -- Changed BOOL to BIT
    b_lock_set_disable_public_chat BIT DEFAULT NULL,  -- Changed BOOL to BIT
    b_lock_set_disable_note BIT DEFAULT NULL,  -- Changed BOOL to BIT
    b_lock_set_locked_layout BIT DEFAULT NULL,  -- Changed BOOL to BIT
    b_lock_set_hide_user_list BIT DEFAULT NULL,  -- Changed BOOL to BIT
    b_lock_set_lock_on_join BIT DEFAULT NULL,  -- Changed BOOL to BIT
    b_lock_set_lock_on_join_conf BIT DEFAULT NULL,  -- Changed BOOL to BIT
    b_permitted_roles NVARCHAR(255) DEFAULT NULL,
    b_join_policy NVARCHAR(32) DEFAULT 'disabled' NOT NULL,
    b_guest_policy NVARCHAR(32) DEFAULT NULL,
    PRIMARY KEY (id)
);

-- Check and create o_bbb_server table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_bbb_server' AND xtype='U')
CREATE TABLE o_bbb_server (
    id BIGINT NOT NULL IDENTITY(1,1),
    creationdate DATETIME2 NOT NULL,
    lastmodified DATETIME2 NOT NULL,
    b_name NVARCHAR(128),
    b_url NVARCHAR(255) NOT NULL,
    b_shared_secret NVARCHAR(255),
    b_recording_url NVARCHAR(255),
    b_enabled BIT DEFAULT 1,  -- Changed BOOL to BIT
    b_manual_only BIT DEFAULT 0 NOT NULL,  -- Changed BOOL to BIT
    b_capacity_factor DECIMAL,
    PRIMARY KEY (id)
);

-- Check and create o_bbb_meeting table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_bbb_meeting' AND xtype='U')
CREATE TABLE o_bbb_meeting (
    id BIGINT NOT NULL IDENTITY(1,1),
    creationdate DATETIME2 NOT NULL,
    lastmodified DATETIME2 NOT NULL,
    b_meeting_id NVARCHAR(128) NOT NULL,
    b_attendee_pw NVARCHAR(128) NOT NULL,
    b_moderator_pw NVARCHAR(128) NOT NULL,
    b_name NVARCHAR(128) NOT NULL,
    b_description NVARCHAR(2000) DEFAULT NULL,
    b_welcome NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
    b_layout NVARCHAR(16) DEFAULT 'standard',
    b_permanent BIT DEFAULT 0 NOT NULL,  -- Changed BOOL to BIT
    b_guest BIT DEFAULT 0 NOT NULL,  -- Changed BOOL to BIT
    b_identifier NVARCHAR(64),
    b_read_identifier NVARCHAR(64),
    b_password NVARCHAR(64),
    b_start_date DATETIME2 DEFAULT NULL,
    b_leadtime BIGINT DEFAULT 0 NOT NULL,
    b_start_with_leadtime DATETIME2,
    b_end_date DATETIME2 DEFAULT NULL,
    b_followuptime BIGINT DEFAULT 0 NOT NULL,
    b_end_with_followuptime DATETIME2,
    b_main_presenter NVARCHAR(255),
    b_directory NVARCHAR(64) DEFAULT NULL,
    b_recordings_publishing NVARCHAR(128) DEFAULT 'all',
    b_record BIT DEFAULT NULL,  -- Changed BOOL to BIT
    b_join_policy NVARCHAR(32) DEFAULT 'disabled' NOT NULL,
    fk_creator_id BIGINT DEFAULT NULL,
    fk_entry_id BIGINT DEFAULT NULL,
    a_sub_ident NVARCHAR(64) DEFAULT NULL,
    fk_group_id BIGINT DEFAULT NULL,
    fk_template_id BIGINT DEFAULT NULL,
    fk_server_id BIGINT,
    PRIMARY KEY (id)
);

-- Check and create o_bbb_attendee table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_bbb_attendee' AND xtype='U')
CREATE TABLE o_bbb_attendee (
    id BIGINT NOT NULL IDENTITY(1,1),
    creationdate DATETIME2 NOT NULL,
    lastmodified DATETIME2 NOT NULL,
    b_role NVARCHAR(32),
    b_join_date DATETIME2,
    b_pseudo NVARCHAR(255),
    fk_identity_id BIGINT,
    fk_meeting_id BIGINT NOT NULL,
    PRIMARY KEY (id)
);

-- Check and create o_bbb_recording table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_bbb_recording' AND xtype='U')
CREATE TABLE o_bbb_recording (
    id BIGINT NOT NULL IDENTITY(1,1),
    creationdate DATETIME2 NOT NULL,
    lastmodified DATETIME2 NOT NULL,
    b_recording_id NVARCHAR(255) NOT NULL,
    b_publish_to NVARCHAR(128),
    b_permanent BIT DEFAULT NULL,  -- Changed BOOL to BIT
    b_start_date DATETIME2 DEFAULT NULL,
    b_end_date DATETIME2 DEFAULT NULL,
    b_url NVARCHAR(1024),
    b_type NVARCHAR(32),
    fk_meeting_id BIGINT NOT NULL,
    UNIQUE(b_recording_id, fk_meeting_id),
    PRIMARY KEY (id)
);

-- Check and create o_teams_meeting table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_teams_meeting' AND xtype='U')
CREATE TABLE o_teams_meeting (
    id BIGINT NOT NULL IDENTITY(1,1),
    creationdate DATETIME2 NOT NULL,
    lastmodified DATETIME2 NOT NULL,
    t_subject NVARCHAR(255),
    t_description NVARCHAR(4000),
    t_main_presenter NVARCHAR(255),
    t_start_date DATETIME2 DEFAULT NULL,
    t_leadtime BIGINT DEFAULT 0 NOT NULL,
    t_start_with_leadtime DATETIME2,
    t_end_date DATETIME2 DEFAULT NULL,
    t_followuptime BIGINT DEFAULT 0 NOT NULL,
    t_end_with_followuptime DATETIME2,
    t_permanent BIT DEFAULT 0,  -- Changed BOOL to BIT
    t_join_information NVARCHAR(4000),
    t_guest BIT DEFAULT 0 NOT NULL,  -- Changed BOOL to BIT
    t_identifier NVARCHAR(64),
    t_read_identifier NVARCHAR(64),
    t_online_meeting_id NVARCHAR(1024),
    t_online_meeting_join_url NVARCHAR(2000),
    t_open_participant BIT NOT NULL DEFAULT 0,  -- Changed BOOL to BIT
    t_allowed_presenters NVARCHAR(32) DEFAULT 'EVERYONE',
    t_access_level NVARCHAR(32) DEFAULT 'EVERYONE',
    t_entry_exit_announcement BIT DEFAULT 1,  -- Changed BOOL to BIT
    t_lobby_bypass_scope NVARCHAR(32) DEFAULT 'ORGANIZATION_AND_FEDERATED',
    fk_entry_id BIGINT DEFAULT NULL,
    a_sub_ident NVARCHAR(64) DEFAULT NULL,
    fk_group_id BIGINT DEFAULT NULL,
    fk_creator_id BIGINT DEFAULT NULL,
    PRIMARY KEY (id)
);

-- Check and create o_teams_user table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_teams_user' AND xtype='U')
CREATE TABLE o_teams_user (
    id BIGINT NOT NULL IDENTITY(1,1),
    creationdate DATETIME2 NOT NULL,
    lastmodified DATETIME2 NOT NULL,
    t_identifier NVARCHAR(128),
    t_displayname NVARCHAR(512),
    fk_identity_id BIGINT DEFAULT NULL,
    UNIQUE(fk_identity_id),
    PRIMARY KEY (id)
);

-- Check and create o_teams_attendee table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_teams_attendee' AND xtype='U')
CREATE TABLE o_teams_attendee (
    id BIGINT NOT NULL IDENTITY(1,1),
    creationdate DATETIME2 NOT NULL,
    lastmodified DATETIME2 NOT NULL,
    t_role NVARCHAR(32),
    t_join_date DATETIME2 NOT NULL,
    fk_identity_id BIGINT DEFAULT NULL,
    fk_teams_user_id BIGINT DEFAULT NULL,
    fk_meeting_id BIGINT NOT NULL,
    PRIMARY KEY (id)
);

-- Check and create o_as_eff_statement table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_as_eff_statement' AND xtype='U')
CREATE TABLE o_as_eff_statement (
    id BIGINT NOT NULL,
    version INT NOT NULL,  -- Changed from MEDIUMINT UNSIGNED to INT
    lastmodified DATETIME2,
    lastcoachmodified DATETIME2,
    lastusermodified DATETIME2,
    creationdate DATETIME2,
    passed BIT DEFAULT NULL,  -- Changed BOOL to BIT
    score NVARCHAR(MAX),  -- Changed FLOAT(65,30) to NVARCHAR(MAX) to handle high precision
    weighted_score NVARCHAR(MAX),  -- Changed FLOAT(65,30) to NVARCHAR(MAX) to handle high precision
    grade NVARCHAR(100),
    grade_system_ident NVARCHAR(64),
    performance_class_ident NVARCHAR(50),
    last_statement BIT DEFAULT 1 NOT NULL,  -- Changed BOOL to BIT
    archive_path NVARCHAR(255),
    archive_certificate BIGINT,
    total_nodes INT,  -- Changed from MEDIUMINT to INT
    attempted_nodes INT,  -- Changed from MEDIUMINT to INT
    passed_nodes INT,  -- Changed from MEDIUMINT to INT
    completion NVARCHAR(MAX),  -- Changed FLOAT(65,30) to NVARCHAR(MAX) to handle high precision
    course_title NVARCHAR(255),
    course_short_title NVARCHAR(128),
    course_repo_key BIGINT,
    statement_xml NVARCHAR(MAX),  -- Changed LONGTEXT to NVARCHAR(MAX)
    fk_identity BIGINT,
    fk_resource_id BIGINT,
    PRIMARY KEY (id)
);



-- fifth round
-- Check and create o_as_user_course_infos table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_as_user_course_infos' AND xtype='U')
CREATE TABLE o_as_user_course_infos (
   id BIGINT NOT NULL,
   version INT NOT NULL,  -- Changed from MEDIUMINT UNSIGNED to INT
   creationdate DATETIME2,
   lastmodified DATETIME2,
   initiallaunchdate DATETIME2,
   recentlaunchdate DATETIME2,
   visit INT,  -- Changed from MEDIUMINT to INT
   run BIGINT DEFAULT 1 NOT NULL,
   timespend BIGINT,
   fk_identity BIGINT,
   fk_resource_id BIGINT,
   PRIMARY KEY (id)
);

-- Check and create o_as_entry table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_as_entry' AND xtype='U')
CREATE TABLE o_as_entry (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   lastcoachmodified DATETIME2,
   lastusermodified DATETIME2,
   a_attemtps BIGINT DEFAULT NULL,
   a_last_attempt DATETIME2 DEFAULT NULL,
   a_score NVARCHAR(MAX) DEFAULT NULL,  -- Changed FLOAT(65,30) to NVARCHAR(MAX)
   a_weighted_score NVARCHAR(MAX) DEFAULT NULL,  -- Changed FLOAT(65,30) to NVARCHAR(MAX)
   a_score_scale NVARCHAR(MAX) DEFAULT NULL,  -- Changed FLOAT(65,30) to NVARCHAR(MAX)
   a_max_score NVARCHAR(MAX) DEFAULT NULL,  -- Changed FLOAT(65,30) to NVARCHAR(MAX)
   a_weighted_max_score NVARCHAR(MAX) DEFAULT NULL,  -- Changed FLOAT(65,30) to NVARCHAR(MAX)
   a_grade NVARCHAR(100),
   a_grade_system_ident NVARCHAR(64),
   a_performance_class_ident NVARCHAR(50),
   a_passed BIT DEFAULT NULL,
   a_passed_date DATETIME2,
   a_passed_original BIT,
   a_passed_mod_date DATETIME2,
   a_status NVARCHAR(16) DEFAULT NULL,
   a_date_done DATETIME2,
   a_details NVARCHAR(1024) DEFAULT NULL,
   a_user_visibility BIT,
   a_share BIT,
   a_fully_assessed BIT DEFAULT NULL,
   a_date_fully_assessed DATETIME2,
   a_assessment_id BIGINT DEFAULT NULL,
   a_completion NVARCHAR(MAX),  -- Changed FLOAT(65,30) to NVARCHAR(MAX)
   a_current_run_completion NVARCHAR(MAX),  -- Changed FLOAT(65,30) to NVARCHAR(MAX)
   a_current_run_status NVARCHAR(16),
   a_current_run_start DATETIME2,
   a_comment NVARCHAR(MAX),  -- Changed TEXT to NVARCHAR(MAX)
   a_coach_comment NVARCHAR(MAX),  -- Changed TEXT to NVARCHAR(MAX)
   a_num_assessment_docs BIGINT NOT NULL DEFAULT 0,
   a_date_start DATETIME2,
   a_date_end DATETIME2,
   a_date_end_original DATETIME2,
   a_date_end_mod_date DATETIME2,
   a_duration BIGINT,  -- Changed from INT8 to BIGINT
   a_obligation NVARCHAR(50),
   a_obligation_inherited NVARCHAR(50),
   a_obligation_evaluated NVARCHAR(50),
   a_obligation_config NVARCHAR(50),
   a_obligation_original NVARCHAR(50),
   a_obligation_mod_date DATETIME2,
   a_first_visit DATETIME2,
   a_last_visit DATETIME2,
   a_num_visits BIGINT,  -- Changed from INT8 to BIGINT
   a_run BIGINT DEFAULT 1 NOT NULL,
   fk_entry BIGINT NOT NULL,
   a_subident NVARCHAR(512),
   a_entry_root BIT DEFAULT NULL,
   fk_reference_entry BIGINT,
   fk_identity BIGINT DEFAULT NULL,
   fk_identity_passed_mod BIGINT,
   fk_identity_end_date_mod BIGINT,
   fk_identity_obligation_mod BIGINT,
   fk_identity_status_done BIGINT,
   a_anon_identifier NVARCHAR(128) DEFAULT NULL,
   a_coach_assignment_date DATETIME2 DEFAULT NULL,
   fk_coach BIGINT DEFAULT NULL,
   PRIMARY KEY (id),
   UNIQUE (fk_identity, fk_entry, a_subident)
);

-- Check and create o_as_score_accounting_trigger table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_as_score_accounting_trigger' AND xtype='U')
CREATE TABLE o_as_score_accounting_trigger (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   e_identifier NVARCHAR(64) NOT NULL,
   e_business_group_key BIGINT,
   e_organisation_key BIGINT,
   e_curriculum_element_key BIGINT,
   e_user_property_name NVARCHAR(64),
   e_user_property_value NVARCHAR(128),
   fk_entry BIGINT NOT NULL,
   e_subident NVARCHAR(64) NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_as_compensation table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_as_compensation' AND xtype='U')
CREATE TABLE o_as_compensation (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   a_subident NVARCHAR(512),
   a_subident_name NVARCHAR(512),
   a_extra_time BIGINT NOT NULL,
   a_approved_by NVARCHAR(2000),
   a_approval DATETIME2,
   a_status NVARCHAR(32),
   fk_identity BIGINT NOT NULL,
   fk_creator BIGINT NOT NULL,
   fk_entry BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_as_compensation_log table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_as_compensation_log' AND xtype='U')
CREATE TABLE o_as_compensation_log (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   a_action NVARCHAR(32) NOT NULL,
   a_val_before NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
   a_val_after NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
   a_subident NVARCHAR(512),
   fk_entry_id BIGINT NOT NULL,
   fk_identity_id BIGINT NOT NULL,
   fk_compensation_id BIGINT NOT NULL,
   fk_author_id BIGINT,
   PRIMARY KEY (id)
);

-- Check and create o_as_mode_course table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_as_mode_course' AND xtype='U')
CREATE TABLE o_as_mode_course (
   id BIGINT NOT NULL,
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   a_name NVARCHAR(255),
   a_description NVARCHAR(MAX),  -- Changed LONGTEXT to NVARCHAR(MAX)
   a_external_id NVARCHAR(64),
   a_managed_flags NVARCHAR(255),
   a_status NVARCHAR(16),
   a_end_status NVARCHAR(32),
   a_manual_beginend BIT NOT NULL DEFAULT 0,
   a_begin DATETIME2 NOT NULL,
   a_leadtime BIGINT NOT NULL DEFAULT 0,
   a_begin_with_leadtime DATETIME2 NOT NULL,
   a_end DATETIME2 NOT NULL,
   a_followuptime BIGINT NOT NULL DEFAULT 0,
   a_end_with_followuptime DATETIME2 NOT NULL,
   a_targetaudience NVARCHAR(16),
   a_restrictaccesselements BIT NOT NULL DEFAULT 0,
   a_elements NVARCHAR(2048),
   a_start_element NVARCHAR(64),
   a_restrictaccessips BIT NOT NULL DEFAULT 0,
   a_ips NVARCHAR(2048),
   a_safeexambrowser BIT NOT NULL DEFAULT 0,
   a_safeexambrowserkey NVARCHAR(2048),
   a_safeexambrowserconfig_xml NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
   a_safeexambrowserconfig_plist NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
   a_safeexambrowserconfig_pkey NVARCHAR(255),
   a_safeexambrowserconfig_dload BIT NOT NULL DEFAULT 1,  -- Changed BOOL to BIT
   a_safeexambrowserhint NVARCHAR(MAX),  -- Changed LONGTEXT to NVARCHAR(MAX)
   a_applysettingscoach BIT NOT NULL DEFAULT 0,
   fk_entry BIGINT NOT NULL,
   fk_lecture_block BIGINT,
   PRIMARY KEY (id)
);

-- Check and create o_as_mode_course_to_group table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_as_mode_course_to_group' AND xtype='U')
CREATE TABLE o_as_mode_course_to_group (
   id BIGINT NOT NULL,
   fk_assessment_mode_id BIGINT NOT NULL,
   fk_group_id BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_as_mode_course_to_area table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_as_mode_course_to_area' AND xtype='U')
CREATE TABLE o_as_mode_course_to_area (
   id BIGINT NOT NULL,
   fk_assessment_mode_id BIGINT NOT NULL,
   fk_area_id BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_as_mode_course_to_cur_el table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_as_mode_course_to_cur_el' AND xtype='U')
CREATE TABLE o_as_mode_course_to_cur_el (
   id BIGINT NOT NULL IDENTITY(1,1),
   fk_assessment_mode_id BIGINT NOT NULL,
   fk_cur_element_id BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_as_inspection_configuration table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_as_inspection_configuration' AND xtype='U')
CREATE TABLE o_as_inspection_configuration (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   a_name NVARCHAR(255),
   a_duration BIGINT NOT NULL,
   a_overview_options NVARCHAR(1000),
   a_restrictaccessips BIT NOT NULL DEFAULT 0,  -- Changed BOOL to BIT
   a_ips NVARCHAR(MAX),  -- Changed TEXT(32000) to NVARCHAR(MAX)
   a_safeexambrowser BIT NOT NULL DEFAULT 0,  -- Changed BOOL to BIT
   a_safeexambrowserkey NVARCHAR(MAX),  -- Changed TEXT(32000) to NVARCHAR(MAX)
   a_safeexambrowserconfig_xml NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
   a_safeexambrowserconfig_plist NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
   a_safeexambrowserconfig_pkey NVARCHAR(255),
   a_safeexambrowserconfig_dload BIT NOT NULL DEFAULT 1,  -- Changed BOOL to BIT
   a_safeexambrowserhint NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
   fk_entry BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_as_inspection table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_as_inspection' AND xtype='U')
CREATE TABLE o_as_inspection (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   a_subident NVARCHAR(512),
   a_from DATETIME2 NOT NULL,
   a_to DATETIME2 NOT NULL,
   a_extra_time BIGINT,
   a_access_code NVARCHAR(128),
   a_start_time DATETIME2,
   a_end_time DATETIME2,
   a_end_by NVARCHAR(16),
   a_effective_duration BIGINT,
   a_comment NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
   a_status NVARCHAR(16) NOT NULL DEFAULT 'published',
   fk_identity BIGINT NOT NULL,
   fk_configuration BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_as_inspection_log table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_as_inspection_log' AND xtype='U')
CREATE TABLE o_as_inspection_log (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   a_action NVARCHAR(32) NOT NULL,
   a_before NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
   a_after NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
   fk_doer BIGINT,
   fk_inspection BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_as_message table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_as_message' AND xtype='U')
CREATE TABLE o_as_message (
   id BIGINT NOT NULL IDENTITY(1,1),
   lastmodified DATETIME2 NOT NULL,
   creationdate DATETIME2 NOT NULL,
   a_message NVARCHAR(2000) NOT NULL,
   a_publication_date DATETIME2 NOT NULL,
   a_expiration_date DATETIME2 NOT NULL,
   a_publication_type NVARCHAR(32) NOT NULL DEFAULT 'asap',
   a_message_sent BIT NOT NULL DEFAULT 0,  -- Changed BOOL to BIT
   fk_entry BIGINT NOT NULL,
   fk_author BIGINT,
   a_ressubpath NVARCHAR(255),
   PRIMARY KEY (id)
);

-- Check and create o_as_message_log table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_as_message_log' AND xtype='U')
CREATE TABLE o_as_message_log (
   id BIGINT NOT NULL IDENTITY(1,1),
   lastmodified DATETIME2 NOT NULL,
   creationdate DATETIME2 NOT NULL,
   a_read BIT NOT NULL DEFAULT 0,  -- Changed BOOL to BIT
   fk_message BIGINT NOT NULL,
   fk_identity BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_cer_template table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_cer_template' AND xtype='U')
CREATE TABLE o_cer_template (
   id BIGINT NOT NULL,
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   c_name NVARCHAR(256) NOT NULL,
   c_path NVARCHAR(1024) NOT NULL,
   c_public BIT NOT NULL,  -- Changed BOOLEAN to BIT
   c_format NVARCHAR(16),
   c_orientation NVARCHAR(16),
   PRIMARY KEY (id)
);

-- Check and create o_cer_certificate table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_cer_certificate' AND xtype='U')
CREATE TABLE o_cer_certificate (
   id BIGINT NOT NULL,
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   c_status NVARCHAR(16) NOT NULL DEFAULT 'pending',
   c_email_status NVARCHAR(16),
   c_uuid NVARCHAR(36) NOT NULL,
   c_external_id NVARCHAR(64),
   c_managed_flags NVARCHAR(255),
   c_next_recertification DATETIME2,
   c_path NVARCHAR(1024),
   c_last BIT NOT NULL DEFAULT 1,  -- Changed BOOLEAN to BIT
   c_course_title NVARCHAR(255),
   c_archived_resource_id BIGINT NOT NULL,
   fk_olatresource BIGINT,
   fk_identity BIGINT NOT NULL,
   fk_metadata BIGINT,
   PRIMARY KEY (id)
);

-- Check and create o_cer_entry_config table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_cer_entry_config' AND xtype='U')
CREATE TABLE o_cer_entry_config (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   c_cer_auto_enabled BIT NOT NULL DEFAULT 0,  -- Changed BOOLEAN to BIT
   c_cer_manual_enabled BIT NOT NULL DEFAULT 0,  -- Changed BOOLEAN to BIT
   c_cer_custom_1 NVARCHAR(4000),
   c_cer_custom_2 NVARCHAR(4000),
   c_cer_custom_3 NVARCHAR(4000),
   c_validity_enabled BIT NOT NULL DEFAULT 0,  -- Changed BOOLEAN to BIT
   c_validity_timelapse BIGINT NOT NULL DEFAULT 0,
   c_validity_timelapse_unit NVARCHAR(32),
   c_recer_enabled BIT NOT NULL DEFAULT 0,  -- Changed BOOLEAN to BIT
   c_recer_leadtime_enabled BIT NOT NULL DEFAULT 0,  -- Changed BOOLEAN to BIT
   c_recer_leadtime_days BIGINT NOT NULL DEFAULT 0,
   fk_template BIGINT,
   fk_entry BIGINT NOT NULL,
   UNIQUE(fk_entry),
   PRIMARY KEY (id)
);

-- Check and create o_gr_grade_system table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_gr_grade_system' AND xtype='U')
CREATE TABLE o_gr_grade_system (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   g_identifier NVARCHAR(64) NOT NULL,
   g_predefined BIT NOT NULL DEFAULT 0,  -- Changed BOOLEAN to BIT
   g_has_passed BIT NOT NULL DEFAULT 1,  -- Changed BOOLEAN to BIT
   g_type NVARCHAR(32) NOT NULL,
   g_enabled BIT NOT NULL DEFAULT 1,  -- Changed BOOLEAN to BIT
   g_resolution NVARCHAR(32),
   g_rounding NVARCHAR(32),
   g_best_grade INT,
   g_lowest_grade INT,
   g_cut_value DECIMAL(38,30),  -- Adjusted precision and scale
   PRIMARY KEY (id)
);

-- Check and create o_gr_performance_class table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_gr_performance_class' AND xtype='U')
CREATE TABLE o_gr_performance_class (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   g_identifier NVARCHAR(50),
   g_best_to_lowest INT,
   g_passed BIT NOT NULL DEFAULT 0,  -- Changed BOOLEAN to BIT
   fk_grade_system BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_gr_grade_scale table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_gr_grade_scale' AND xtype='U')
CREATE TABLE o_gr_grade_scale (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   g_min_score DECIMAL(38,30),  -- Adjusted precision and scale
   g_max_score DECIMAL(38,30),  -- Adjusted precision and scale
   fk_grade_system BIGINT,
   fk_entry BIGINT NOT NULL,
   g_subident NVARCHAR(64) NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_gr_breakpoint table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_gr_breakpoint' AND xtype='U')
CREATE TABLE o_gr_breakpoint (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   g_score DECIMAL(38,30),  -- Adjusted precision and scale
   g_grade NVARCHAR(50),
   g_best_to_lowest INT,
   fk_grade_scale BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_goto_organizer table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_goto_organizer' AND xtype='U')
CREATE TABLE o_goto_organizer (
   id BIGINT NOT NULL,
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   g_name NVARCHAR(128) DEFAULT NULL,
   g_account_key NVARCHAR(128) DEFAULT NULL,
   g_access_token NVARCHAR(4000) NOT NULL,
   g_renew_date DATETIME2 NOT NULL,
   g_refresh_token NVARCHAR(4000),
   g_renew_refresh_date DATETIME2,
   g_organizer_key NVARCHAR(128) NOT NULL,
   g_username NVARCHAR(128) NOT NULL,
   g_firstname NVARCHAR(128) DEFAULT NULL,
   g_lastname NVARCHAR(128) DEFAULT NULL,
   g_email NVARCHAR(128) DEFAULT NULL,
   fk_identity BIGINT DEFAULT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_goto_meeting table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_goto_meeting' AND xtype='U')
CREATE TABLE o_goto_meeting (
   id BIGINT NOT NULL,
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   g_external_id NVARCHAR(128) DEFAULT NULL,
   g_type NVARCHAR(16) NOT NULL,
   g_meeting_key NVARCHAR(128) NOT NULL,
   g_name NVARCHAR(255) DEFAULT NULL,
   g_description NVARCHAR(2000) DEFAULT NULL,
   g_start_date DATETIME2 DEFAULT NULL,
   g_end_date DATETIME2 DEFAULT NULL,
   fk_organizer_id BIGINT NOT NULL,
   fk_entry_id BIGINT DEFAULT NULL,
   g_sub_ident NVARCHAR(64) DEFAULT NULL,
   fk_group_id BIGINT DEFAULT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_goto_registrant table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_goto_registrant' AND xtype='U')
CREATE TABLE o_goto_registrant (
   id BIGINT NOT NULL,
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   g_status NVARCHAR(16) DEFAULT NULL,
   g_join_url NVARCHAR(1024) DEFAULT NULL,
   g_confirm_url NVARCHAR(1024) DEFAULT NULL,
   g_registrant_key NVARCHAR(64) DEFAULT NULL,
   fk_meeting_id BIGINT NOT NULL,
   fk_identity_id BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_vid_transcoding table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_vid_transcoding' AND xtype='U')
CREATE TABLE o_vid_transcoding (
   id BIGINT NOT NULL,
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   vid_resolution BIGINT DEFAULT NULL,
   vid_width BIGINT DEFAULT NULL,
   vid_height BIGINT DEFAULT NULL,
   vid_size BIGINT DEFAULT NULL,
   vid_format NVARCHAR(128) DEFAULT NULL,
   vid_status BIGINT DEFAULT NULL,
   vid_transcoder NVARCHAR(128) DEFAULT NULL,
   fk_resource_id BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_vid_metadata table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_vid_metadata' AND xtype='U')
CREATE TABLE o_vid_metadata (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   vid_width BIGINT DEFAULT NULL,
   vid_height BIGINT DEFAULT NULL,
   vid_size BIGINT DEFAULT NULL,
   vid_format NVARCHAR(32) DEFAULT NULL,
   vid_length NVARCHAR(32) DEFAULT NULL,
   vid_url NVARCHAR(512) DEFAULT NULL,
   vid_download_enabled BIT NOT NULL DEFAULT 0,  -- Changed BOOLEAN to BIT
   fk_resource_id BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_vid_to_organisation table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_vid_to_organisation' AND xtype='U')
CREATE TABLE o_vid_to_organisation (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   fk_entry BIGINT NOT NULL,
   fk_organisation BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_vid_task_session table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_vid_task_session' AND xtype='U')
CREATE TABLE o_vid_task_session (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   v_author_mode BIT DEFAULT 0,  -- Changed BOOLEAN to BIT
   v_finish_time DATETIME2,
   v_score NVARCHAR(MAX) DEFAULT NULL,  -- Changed FLOAT(65,30) to NVARCHAR(MAX)
   v_max_score NVARCHAR(MAX) DEFAULT NULL,  -- Changed FLOAT(65,30) to NVARCHAR(MAX)
   v_passed BIT DEFAULT NULL,  -- Changed BOOLEAN to BIT
   v_result NVARCHAR(MAX) DEFAULT NULL,  -- Changed FLOAT(65,30) to NVARCHAR(MAX)
   v_segments BIGINT NOT NULL DEFAULT 0,
   v_attempt BIGINT NOT NULL DEFAULT 1,
   v_cancelled BIT DEFAULT 0,  -- Changed BOOLEAN to BIT
   fk_reference_entry BIGINT NOT NULL,
   fk_entry BIGINT,
   v_subident NVARCHAR(255),
   fk_identity BIGINT DEFAULT NULL,
   v_anon_identifier NVARCHAR(128) DEFAULT NULL,
   fk_assessment_entry BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_vid_task_selection table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_vid_task_selection' AND xtype='U')
CREATE TABLE o_vid_task_selection (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   v_segment_id NVARCHAR(64),
   v_category_id NVARCHAR(64),
   v_correct BIT DEFAULT 0,  -- Changed BOOLEAN to BIT
   v_time BIGINT NOT NULL,
   v_raw_time NVARCHAR(255),
   fk_task_session BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_cal_use_config table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_cal_use_config' AND xtype='U')
CREATE TABLE o_cal_use_config (
   id BIGINT NOT NULL,
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   c_calendar_id NVARCHAR(128) NOT NULL,
   c_calendar_type NVARCHAR(16) NOT NULL,
   c_token NVARCHAR(36),
   c_cssclass NVARCHAR(36),
   c_visible BIT NOT NULL DEFAULT 1,  -- Changed BOOLEAN to BIT
   c_aggregated_feed BIT NOT NULL DEFAULT 1,  -- Changed BOOLEAN to BIT
   fk_identity BIGINT NOT NULL,
   PRIMARY KEY (id),
   UNIQUE (c_calendar_id, c_calendar_type, fk_identity)
);

-- Check and create o_cal_import table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_cal_import' AND xtype='U')
CREATE TABLE o_cal_import (
   id BIGINT NOT NULL,
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   c_calendar_id NVARCHAR(128) NOT NULL,
   c_calendar_type NVARCHAR(16) NOT NULL,
   c_displayname NVARCHAR(256),
   c_lastupdate DATETIME2 NOT NULL,
   c_url NVARCHAR(1024),
   fk_identity BIGINT,
   PRIMARY KEY (id)
);

-- Check and create o_cal_import_to table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_cal_import_to' AND xtype='U')
CREATE TABLE o_cal_import_to (
   id BIGINT NOT NULL,
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   c_to_calendar_id NVARCHAR(128) NOT NULL,
   c_to_calendar_type NVARCHAR(16) NOT NULL,
   c_lastupdate DATETIME2 NOT NULL,
   c_url NVARCHAR(1024),
   PRIMARY KEY (id)
);


-- sixth round

-- Check and create o_im_message table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_im_message' AND xtype='U')
CREATE TABLE o_im_message (
   id BIGINT NOT NULL,
   creationdate DATETIME2,
   msg_resname NVARCHAR(50) NOT NULL,
   msg_resid BIGINT NOT NULL,
   msg_ressubpath NVARCHAR(255),
   msg_channel NVARCHAR(255),
   msg_type NVARCHAR(16) NOT NULL DEFAULT 'text',
   msg_anonym BIT DEFAULT 0,
   msg_from NVARCHAR(255) NOT NULL,
   msg_body NVARCHAR(MAX),  -- Changed LONGTEXT to NVARCHAR(MAX)
   fk_from_identity_id BIGINT NOT NULL,
   fk_meeting_id BIGINT,
   fk_teams_id BIGINT,
   PRIMARY KEY (id)
);

-- Check and create o_im_notification table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_im_notification' AND xtype='U')
CREATE TABLE o_im_notification (
   id BIGINT NOT NULL,
   creationdate DATETIME2,
   chat_resname NVARCHAR(50) NOT NULL,
   chat_resid BIGINT NOT NULL,
   chat_ressubpath NVARCHAR(255),
   chat_channel NVARCHAR(255),
   chat_type NVARCHAR(16) NOT NULL DEFAULT 'message',
   fk_to_identity_id BIGINT NOT NULL,
   fk_from_identity_id BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_im_roster_entry table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_im_roster_entry' AND xtype='U')
CREATE TABLE o_im_roster_entry (
   id BIGINT NOT NULL,
   creationdate DATETIME2,
   r_resname NVARCHAR(50) NOT NULL,
   r_resid BIGINT NOT NULL,
   r_ressubpath NVARCHAR(255),
   r_channel NVARCHAR(255),
   r_nickname NVARCHAR(255),
   r_fullname NVARCHAR(255),
   r_anonym BIT DEFAULT 0,
   r_vip BIT DEFAULT 0,
   r_persistent BIT NOT NULL DEFAULT 0,  -- Changed BOOL to BIT
   r_active BIT NOT NULL DEFAULT 1,  -- Changed BOOL to BIT
   r_read_upto DATETIME2,
   fk_identity_id BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_im_preferences table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_im_preferences' AND xtype='U')
CREATE TABLE o_im_preferences (
   id BIGINT NOT NULL,
   creationdate DATETIME2,
   visible_to_others BIT DEFAULT 0,
   roster_def_status NVARCHAR(12),
   fk_from_identity_id BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_mapper table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_mapper' AND xtype='U')
CREATE TABLE o_mapper (
   id BIGINT NOT NULL,
   lastmodified DATETIME2,
   creationdate DATETIME2,
   expirationdate DATETIME2,
   mapper_uuid NVARCHAR(64),
   orig_session_id NVARCHAR(64),
   xml_config NVARCHAR(MAX),  -- Changed TEXT to NVARCHAR(MAX)
   PRIMARY KEY (id)
);

-- Check and create o_qti_assessmenttest_session table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_qti_assessmenttest_session' AND xtype='U')
CREATE TABLE o_qti_assessmenttest_session (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   q_exploded BIT NOT NULL DEFAULT 0,
   q_cancelled BIT NOT NULL DEFAULT 0,
   q_author_mode BIT NOT NULL DEFAULT 0,
   q_finish_time DATETIME2,
   q_termination_time DATETIME2,
   q_duration BIGINT,
   q_score NVARCHAR(MAX) DEFAULT NULL,  -- Changed FLOAT(65,30) to NVARCHAR(MAX)
   q_manual_score NVARCHAR(MAX) DEFAULT NULL,  -- Changed FLOAT(65,30) to NVARCHAR(MAX)
   q_max_score NVARCHAR(MAX) DEFAULT NULL,  -- Changed FLOAT(65,30) to NVARCHAR(MAX)
   q_passed BIT DEFAULT NULL,
   q_num_questions BIGINT,
   q_num_answered_questions BIGINT,
   q_extra_time BIGINT,
   q_compensation_extra_time BIGINT,
   q_storage NVARCHAR(1024),
   fk_reference_entry BIGINT NOT NULL,
   fk_entry BIGINT,
   q_subident NVARCHAR(255),
   fk_identity BIGINT DEFAULT NULL,
   q_anon_identifier NVARCHAR(128) DEFAULT NULL,
   fk_assessment_entry BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_qti_assessmentitem_session table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_qti_assessmentitem_session' AND xtype='U')
CREATE TABLE o_qti_assessmentitem_session (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   q_itemidentifier NVARCHAR(255) NOT NULL,
   q_sectionidentifier NVARCHAR(255) DEFAULT NULL,
   q_testpartidentifier NVARCHAR(255) DEFAULT NULL,
   q_duration BIGINT,
   q_score NVARCHAR(MAX) DEFAULT NULL,  -- Changed FLOAT(65,30) to NVARCHAR(MAX)
   q_manual_score NVARCHAR(MAX) DEFAULT NULL,  -- Changed FLOAT(65,30) to NVARCHAR(MAX)
   q_coach_comment NVARCHAR(MAX) DEFAULT NULL,  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
   q_to_review BIT DEFAULT 0,
   q_passed BIT DEFAULT NULL,
   q_storage NVARCHAR(1024),
   q_attempts BIGINT DEFAULT NULL,
   q_externalrefidentifier NVARCHAR(64) DEFAULT NULL,
   fk_assessmenttest_session BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_qti_assessment_response table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_qti_assessment_response' AND xtype='U')
CREATE TABLE o_qti_assessment_response (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   q_responseidentifier NVARCHAR(255) NOT NULL,
   q_responsedatatype NVARCHAR(16) NOT NULL,
   q_responselegality NVARCHAR(16) NOT NULL,
   q_stringuifiedresponse NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
   fk_assessmentitem_session BIGINT NOT NULL,
   fk_assessmenttest_session BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_qti_assessment_marks table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_qti_assessment_marks' AND xtype='U')
CREATE TABLE o_qti_assessment_marks (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   q_marks NVARCHAR(MAX) DEFAULT NULL,  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
   q_hidden_rubrics NVARCHAR(MAX) DEFAULT NULL,  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
   fk_reference_entry BIGINT NOT NULL,
   fk_entry BIGINT,
   q_subident NVARCHAR(64),
   fk_identity BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_practice_resource table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_practice_resource' AND xtype='U')
CREATE TABLE o_practice_resource (
   id BIGINT NOT NULL IDENTITY(1,1),
   lastmodified DATETIME2 NOT NULL,
   creationdate DATETIME2 NOT NULL,
   fk_entry BIGINT NOT NULL,
   p_subident NVARCHAR(64) NOT NULL,
   fk_test_entry BIGINT,
   fk_item_collection BIGINT,
   fk_pool BIGINT,
   fk_resource_share BIGINT,
   PRIMARY KEY (id)
);

-- Check and create o_practice_global_item_ref table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_practice_global_item_ref' AND xtype='U')
CREATE TABLE o_practice_global_item_ref (
   id BIGINT NOT NULL IDENTITY(1,1),
   lastmodified DATETIME2 NOT NULL,
   creationdate DATETIME2 NOT NULL,
   p_identifier NVARCHAR(64) NOT NULL,
   p_level BIGINT DEFAULT 0,
   p_attempts BIGINT DEFAULT 0,
   p_correct_answers BIGINT DEFAULT 0,
   p_incorrect_answers BIGINT DEFAULT 0,
   p_last_attempt_date DATETIME2,
   p_last_attempt_passed BIT DEFAULT NULL,  -- Changed BOOLEAN to BIT
   fk_identity BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_qp_pool table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_qp_pool' AND xtype='U')
CREATE TABLE o_qp_pool (
   id BIGINT NOT NULL,
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   q_name NVARCHAR(255) NOT NULL,
   q_public BIT DEFAULT 0,
   fk_ownergroup BIGINT,
   PRIMARY KEY (id)
);

-- Check and create o_qp_taxonomy_level table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_qp_taxonomy_level' AND xtype='U')
CREATE TABLE o_qp_taxonomy_level (
   id BIGINT NOT NULL,
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   q_field NVARCHAR(255) NOT NULL,
   q_mat_path_ids NVARCHAR(1024),
   q_mat_path_names NVARCHAR(2048),
   fk_parent_field BIGINT,
   PRIMARY KEY (id)
);

-- Check and create o_qp_item table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_qp_item' AND xtype='U')
CREATE TABLE o_qp_item (
   id BIGINT NOT NULL,
   q_identifier NVARCHAR(36) NOT NULL,
   q_master_identifier NVARCHAR(36),
   q_title NVARCHAR(1024) NOT NULL,
   q_topic NVARCHAR(1024),
   q_description NVARCHAR(2048),
   q_keywords NVARCHAR(1024),
   q_coverage NVARCHAR(1024),
   q_additional_informations NVARCHAR(256),
   q_language NVARCHAR(16),
   fk_edu_context BIGINT,
   q_educational_learningtime NVARCHAR(32),
   fk_type BIGINT,
   q_difficulty DECIMAL(10,9),
   q_stdev_difficulty DECIMAL(10,9),
   q_differentiation DECIMAL(10,9),
   q_num_of_answers_alt BIGINT NOT NULL DEFAULT 0,
   q_usage BIGINT NOT NULL DEFAULT 0,
   q_correction_time BIGINT DEFAULT NULL,
   q_assessment_type NVARCHAR(64),
   q_status NVARCHAR(32) NOT NULL,
   q_version NVARCHAR(50),
   fk_license BIGINT,
   q_editor NVARCHAR(256),
   q_editor_version NVARCHAR(256),
   q_format NVARCHAR(32) NOT NULL,
   q_creator NVARCHAR(1024),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   q_status_last_modified DATETIME2 NOT NULL,
   q_dir NVARCHAR(32),
   q_root_filename NVARCHAR(255),
   fk_taxonomy_level BIGINT,
   fk_taxonomy_level_v2 BIGINT,
   fk_ownergroup BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_qp_item_audit_log table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_qp_item_audit_log' AND xtype='U')
CREATE TABLE o_qp_item_audit_log (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   q_action NVARCHAR(64),
   q_val_before NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
   q_val_after NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
   q_lic_before NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
   q_lic_after NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
   q_message NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
   fk_author_id BIGINT,
   fk_item_id BIGINT,
   PRIMARY KEY (id)
);

-- Check and create o_qp_pool_2_item table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_qp_pool_2_item' AND xtype='U')
CREATE TABLE o_qp_pool_2_item (
   id BIGINT NOT NULL,
   creationdate DATETIME2 NOT NULL,
   q_editable BIT DEFAULT 0,
   fk_pool_id BIGINT NOT NULL,
   fk_item_id BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_qp_share_item table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_qp_share_item' AND xtype='U')
CREATE TABLE o_qp_share_item (
   id BIGINT NOT NULL,
   creationdate DATETIME2 NOT NULL,
   q_editable BIT DEFAULT 0,
   fk_resource_id BIGINT NOT NULL,
   fk_item_id BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_qp_item_collection table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_qp_item_collection' AND xtype='U')
CREATE TABLE o_qp_item_collection (
   id BIGINT NOT NULL,
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   q_name NVARCHAR(256),
   fk_owner_id BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_qp_collection_2_item table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_qp_collection_2_item' AND xtype='U')
CREATE TABLE o_qp_collection_2_item (
   id BIGINT NOT NULL,
   creationdate DATETIME2 NOT NULL,
   fk_collection_id BIGINT NOT NULL,
   fk_item_id BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_qp_edu_context table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_qp_edu_context' AND xtype='U')
CREATE TABLE o_qp_edu_context (
   id BIGINT NOT NULL,
   creationdate DATETIME2 NOT NULL,
   q_level NVARCHAR(256) NOT NULL,
   q_deletable BIT DEFAULT 0,
   PRIMARY KEY (id)
);

-- Check and create o_qp_item_type table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_qp_item_type' AND xtype='U')
CREATE TABLE o_qp_item_type (
   id BIGINT NOT NULL,
   creationdate DATETIME2 NOT NULL,
   q_type NVARCHAR(256) NOT NULL,
   q_deletable BIT DEFAULT 0,
   PRIMARY KEY (id)
);

-- Check and create o_qp_license table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_qp_license' AND xtype='U')
CREATE TABLE o_qp_license (
   id BIGINT NOT NULL,
   creationdate DATETIME2 NOT NULL,
   q_license NVARCHAR(256) NOT NULL,
   q_text NVARCHAR(2048),
   q_deletable BIT DEFAULT 0,
   PRIMARY KEY (id)
);

-- Check and create o_vfs_metadata table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_vfs_metadata' AND xtype='U')
CREATE TABLE o_vfs_metadata (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   f_uuid NVARCHAR(64) NOT NULL,
   f_deleted BIT NOT NULL DEFAULT 0,  -- Changed BOOLEAN to BIT
   f_filename NVARCHAR(256) NOT NULL,
   f_relative_path NVARCHAR(2048) NOT NULL,
   f_directory BIT DEFAULT 0,  -- Changed BOOL to BIT
   f_lastmodified DATETIME2 NOT NULL,
   f_size BIGINT DEFAULT 0,
   f_transcoding_status BIGINT,
   f_uri NVARCHAR(2000) NOT NULL,
   f_uri_protocol NVARCHAR(16) NOT NULL,
   f_cannot_thumbnails BIT DEFAULT 0,  -- Changed BOOL to BIT
   f_download_count BIGINT DEFAULT 0,
   f_comment NVARCHAR(MAX),  -- Changed TEXT to NVARCHAR(MAX)
   f_title NVARCHAR(2000),
   f_publisher NVARCHAR(2000),
   f_creator NVARCHAR(2000),
   f_source NVARCHAR(2000),
   f_city NVARCHAR(256),
   f_pages NVARCHAR(16),
   f_language NVARCHAR(16),
   f_url NVARCHAR(MAX),  -- Changed TEXT to NVARCHAR(MAX)
   f_pub_month NVARCHAR(16),
   f_pub_year NVARCHAR(16),
   f_license_type_name NVARCHAR(256),
   f_license_text NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
   f_licensor NVARCHAR(MAX),  -- Changed TEXT to NVARCHAR(MAX)
   f_locked_date DATETIME2,
   f_locked BIT DEFAULT 0,  -- Changed BOOL to BIT
   f_expiration_date DATETIME2,
   f_migrated NVARCHAR(12),
   f_m_path_keys NVARCHAR(1024),
   fk_locked_identity BIGINT,
   f_revision_nr BIGINT DEFAULT 0 NOT NULL,
   f_revision_temp_nr BIGINT,
   f_revision_comment NVARCHAR(MAX),  -- Changed TEXT to NVARCHAR(MAX)
   fk_license_type BIGINT,
   fk_initialized_by BIGINT,
   fk_lastmodified_by BIGINT,
   fk_parent BIGINT,
   PRIMARY KEY (id)
);

-- Check and create o_vfs_thumbnail table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_vfs_thumbnail' AND xtype='U')
CREATE TABLE o_vfs_thumbnail (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   f_size BIGINT NOT NULL DEFAULT 0,
   f_max_width BIGINT NOT NULL DEFAULT 0,
   f_max_height BIGINT NOT NULL DEFAULT 0,
   f_final_width BIGINT NOT NULL DEFAULT 0,
   f_final_height BIGINT NOT NULL DEFAULT 0,
   f_fill BIT NOT NULL DEFAULT 0,  -- Changed BOOL to BIT
   f_filename NVARCHAR(256) NOT NULL,
   fk_metadata BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_vfs_revision table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_vfs_revision' AND xtype='U')
CREATE TABLE o_vfs_revision (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   f_revision_size BIGINT NOT NULL DEFAULT 0,
   f_revision_nr BIGINT NOT NULL DEFAULT 0,
   f_revision_temp_nr BIGINT,
   f_revision_filename NVARCHAR(256) NOT NULL,
   f_revision_comment NVARCHAR(MAX),  -- Changed TEXT to NVARCHAR(MAX)
   f_revision_lastmodified DATETIME2 NOT NULL,
   f_comment NVARCHAR(MAX),  -- Changed TEXT to NVARCHAR(MAX)
   f_title NVARCHAR(2000),
   f_publisher NVARCHAR(2000),
   f_creator NVARCHAR(2000),
   f_source NVARCHAR(2000),
   f_city NVARCHAR(256),
   f_pages NVARCHAR(16),
   f_language NVARCHAR(16),
   f_url NVARCHAR(MAX),  -- Changed TEXT to NVARCHAR(MAX)
   f_pub_month NVARCHAR(16),
   f_pub_year NVARCHAR(16),
   f_license_type_name NVARCHAR(256),
   f_license_text NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
   f_licensor NVARCHAR(MAX),  -- Changed TEXT to NVARCHAR(MAX)
   fk_license_type BIGINT,
   fk_initialized_by BIGINT,
   fk_lastmodified_by BIGINT,
   fk_metadata BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_vfs_statistics table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_vfs_statistics' AND xtype='U')
CREATE TABLE o_vfs_statistics (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   f_files_amount BIGINT DEFAULT 0,
   f_files_size BIGINT DEFAULT 0,
   f_trash_amount BIGINT DEFAULT 0,
   f_trash_size BIGINT DEFAULT 0,
   f_revisions_amount BIGINT DEFAULT 0,
   f_revisions_size BIGINT DEFAULT 0,
   f_thumbnails_amount BIGINT DEFAULT 0,
   f_thumbnails_size BIGINT DEFAULT 0,
   PRIMARY KEY (id)
);

-- Check and create o_de_access table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_de_access' AND xtype='U')
CREATE TABLE o_de_access (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   o_editor_type NVARCHAR(64) NOT NULL,
   o_expires_at DATETIME2 NOT NULL,
   o_mode NVARCHAR(64) NOT NULL,
   o_edit_start_date DATETIME2,
   o_version_controlled BIT NOT NULL,  -- Changed BOOLEAN to BIT
   o_download BIT DEFAULT 1,  -- Changed BOOLEAN to BIT
   o_fire_saved_event BIT DEFAULT 0,  -- Changed BOOLEAN to BIT
   fk_metadata BIGINT NOT NULL,
   fk_identity BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_de_user_info table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_de_user_info' AND xtype='U')
CREATE TABLE o_de_user_info (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   o_info NVARCHAR(2048) NOT NULL,
   fk_identity BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_pf_binder table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_pf_binder' AND xtype='U')
CREATE TABLE o_pf_binder (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   p_title NVARCHAR(255),
   p_status NVARCHAR(32),
   p_copy_date DATETIME2,
   p_return_date DATETIME2,
   p_deadline DATETIME2,
   p_summary NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
   p_image_path NVARCHAR(255),
   fk_olatresource_id BIGINT,
   fk_group_id BIGINT NOT NULL,
   fk_entry_id BIGINT,
   p_subident NVARCHAR(128),
   fk_template_id BIGINT,
   PRIMARY KEY (id)
);


-- seventh round
-- Check and create o_pf_section table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_pf_section' AND xtype='U')
CREATE TABLE o_pf_section (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   pos BIGINT DEFAULT NULL,
   p_title NVARCHAR(255),
   p_description NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
   p_status NVARCHAR(32) NOT NULL DEFAULT 'notStarted',
   p_begin DATETIME2,
   p_end DATETIME2,
   p_override_begin_end BIT DEFAULT 0,  -- Changed BOOL to BIT
   fk_group_id BIGINT NOT NULL,
   fk_binder_id BIGINT NOT NULL,
   fk_template_reference_id BIGINT,
   PRIMARY KEY (id)
);

-- Check and create o_ce_page table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_ce_page' AND xtype='U')
CREATE TABLE o_ce_page (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   pos BIGINT DEFAULT NULL,
   p_editable BIT DEFAULT 1,  -- Changed BOOL to BIT
   p_title NVARCHAR(255),
   p_summary NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
   p_status NVARCHAR(32),
   p_image_path NVARCHAR(255),
   p_image_align NVARCHAR(32),
   p_preview_path NVARCHAR(255),
   p_version BIGINT DEFAULT 0,
   p_initial_publish_date DATETIME2,
   p_last_publish_date DATETIME2,
   fk_body_id BIGINT NOT NULL,
   fk_group_id BIGINT NOT NULL,
   fk_section_id BIGINT,
   fk_preview_metadata BIGINT,
   PRIMARY KEY (id)
);

-- Check and create o_ce_page_body table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_ce_page_body' AND xtype='U')
CREATE TABLE o_ce_page_body (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   p_usage BIGINT DEFAULT 0,
   p_synthetic_status NVARCHAR(32),
   PRIMARY KEY (id)
);

-- Check and create o_media table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_media' AND xtype='U')
CREATE TABLE o_media (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   p_collection_date DATETIME2 NOT NULL,
   p_type NVARCHAR(64) NOT NULL,
   p_storage_path NVARCHAR(255),
   p_root_filename NVARCHAR(255),
   p_title NVARCHAR(255) NOT NULL,
   p_description NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
   p_content NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
   p_alt_text NVARCHAR(2000),
   p_uuid NVARCHAR(48),
   p_signature BIGINT NOT NULL DEFAULT 0,
   p_reference_id NVARCHAR(255) DEFAULT NULL,
   p_business_path NVARCHAR(255) DEFAULT NULL,
   p_creators NVARCHAR(1024) DEFAULT NULL,
   p_place NVARCHAR(255) DEFAULT NULL,
   p_publisher NVARCHAR(255) DEFAULT NULL,
   p_publication_date DATETIME2 DEFAULT NULL,
   p_date NVARCHAR(32) DEFAULT NULL,
   p_url NVARCHAR(1024) DEFAULT NULL,
   p_source NVARCHAR(1024) DEFAULT NULL,
   p_language NVARCHAR(32) DEFAULT NULL,
   p_metadata_xml NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
   fk_author_id BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_media_tag table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_media_tag' AND xtype='U')
CREATE TABLE o_media_tag (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   fk_media BIGINT NOT NULL,
   fk_tag BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_media_to_tax_level table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_media_to_tax_level' AND xtype='U')
CREATE TABLE o_media_to_tax_level (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   fk_media BIGINT NOT NULL,
   fk_taxonomy_level BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_media_to_group table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_media_to_group' AND xtype='U')
CREATE TABLE o_media_to_group (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   p_type NVARCHAR(32),
   p_editable BIT DEFAULT 0 NOT NULL,  -- Changed BOOL to BIT
   fk_media BIGINT NOT NULL,
   fk_group BIGINT,
   fk_repositoryentry BIGINT,
   PRIMARY KEY (id)
);

-- Check and create o_media_version table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_media_version' AND xtype='U')
CREATE TABLE o_media_version (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   pos BIGINT DEFAULT NULL,
   p_version NVARCHAR(32),
   p_version_uuid NVARCHAR(48),
   p_version_checksum NVARCHAR(128),
   p_collection_date DATETIME2 NOT NULL,
   p_storage_path NVARCHAR(255),
   p_root_filename NVARCHAR(255),
   p_content NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
   fk_media BIGINT NOT NULL,
   fk_metadata BIGINT,
   fk_version_metadata BIGINT,
   PRIMARY KEY (id)
);

-- Check and create o_media_version_metadata table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_media_version_metadata' AND xtype='U')
CREATE TABLE o_media_version_metadata (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   p_url NVARCHAR(1024) DEFAULT NULL,
   p_width BIGINT DEFAULT NULL,
   p_height BIGINT DEFAULT NULL,
   p_length NVARCHAR(32) DEFAULT NULL,
   p_format NVARCHAR(32) DEFAULT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_media_log table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_media_log' AND xtype='U')
CREATE TABLE o_media_log (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   p_action NVARCHAR(32),
   p_temp_identifier NVARCHAR(100),
   fk_media BIGINT NOT NULL,
   fk_identity BIGINT,
   PRIMARY KEY (id)
);

-- Check and create o_ce_page_reference table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_ce_page_reference' AND xtype='U')
CREATE TABLE o_ce_page_reference  (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   fk_page BIGINT NOT NULL,
   fk_entry BIGINT NOT NULL,
   p_subident NVARCHAR(512) DEFAULT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_ce_page_part table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_ce_page_part' AND xtype='U')
CREATE TABLE o_ce_page_part (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   pos BIGINT DEFAULT NULL,
   dtype NVARCHAR(32),
   p_content NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
   p_flow NVARCHAR(32),
   p_layout_options NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
   fk_media_id BIGINT,
   fk_page_body_id BIGINT,
   fk_form_entry_id BIGINT DEFAULT NULL,
   fk_media_version_id BIGINT DEFAULT NULL,
   fk_identity_id BIGINT,
   PRIMARY KEY (id)
);

-- Check and create o_pf_category table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_pf_category' AND xtype='U')
CREATE TABLE o_pf_category (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   p_name NVARCHAR(32),
   PRIMARY KEY (id)
);

-- Check and create o_pf_category_relation table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_pf_category_relation' AND xtype='U')
CREATE TABLE o_pf_category_relation (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   p_resname NVARCHAR(64) NOT NULL,
   p_resid BIGINT NOT NULL,
   fk_category_id BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_pf_assessment_section table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_pf_assessment_section' AND xtype='U')
CREATE TABLE o_pf_assessment_section (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   p_score DECIMAL(38,30) DEFAULT NULL,  -- Changed from FLOAT(65,30) to DECIMAL(38,30)
   p_passed BIT DEFAULT NULL,  -- Changed BOOL to BIT
   p_comment NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
   fk_section_id BIGINT NOT NULL,
   fk_identity_id BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_ce_assignment table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_ce_assignment' AND xtype='U')
CREATE TABLE o_ce_assignment (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   pos BIGINT DEFAULT NULL,
   p_status NVARCHAR(32) DEFAULT NULL,
   p_type NVARCHAR(32) NOT NULL,
   p_version BIGINT NOT NULL DEFAULT 0,
   p_template BIT DEFAULT 0,  -- Changed BOOL to BIT
   p_title NVARCHAR(255) DEFAULT NULL,
   p_summary NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
   p_content NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
   p_storage NVARCHAR(255) DEFAULT NULL,
   fk_section_id BIGINT,
   fk_binder_id BIGINT,
   fk_template_reference_id BIGINT,
   fk_page_id BIGINT,
   fk_assignee_id BIGINT,
   p_only_auto_eva BIT DEFAULT 1,  -- Changed BOOL to BIT
   p_reviewer_see_auto_eva BIT DEFAULT 0,  -- Changed BOOL to BIT
   p_anon_extern_eva BIT DEFAULT 1,  -- Changed BOOL to BIT
   fk_form_entry_id BIGINT DEFAULT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_pf_binder_user_infos table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_pf_binder_user_infos' AND xtype='U')
CREATE TABLE o_pf_binder_user_infos (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   p_initiallaunchdate DATETIME2,
   p_recentlaunchdate DATETIME2,
   p_visit BIGINT,
   fk_identity BIGINT,
   fk_binder BIGINT,
   PRIMARY KEY (id),
   UNIQUE (fk_identity, fk_binder)
);

-- Check and create o_ce_page_user_infos table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_ce_page_user_infos' AND xtype='U')
CREATE TABLE o_ce_page_user_infos (
  id BIGINT NOT NULL IDENTITY(1,1),
  creationdate DATETIME2 NOT NULL,
  lastmodified DATETIME2 NOT NULL,
  p_mark BIT DEFAULT 0,  -- Changed BOOL to BIT
  p_status NVARCHAR(16) NOT NULL DEFAULT 'incoming',
  p_recentlaunchdate DATETIME2 NOT NULL,
  fk_identity_id BIGINT NOT NULL,
  fk_page_id BIGINT NOT NULL,
  PRIMARY KEY (id)
);

-- Check and create o_ce_page_to_tax_competence table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_ce_page_to_tax_competence' AND xtype='U')
CREATE TABLE o_ce_page_to_tax_competence (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   fk_tax_competence BIGINT NOT NULL,
   fk_pf_page BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_ce_audit_log table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_ce_audit_log' AND xtype='U')
CREATE TABLE o_ce_audit_log (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   p_action NVARCHAR(32),
   p_before NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
   p_after NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
   fk_doer BIGINT,
   fk_page BIGINT,
   PRIMARY KEY (id)
);

-- Check and create o_eva_form_survey table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_eva_form_survey' AND xtype='U')
CREATE TABLE o_eva_form_survey (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   e_resname NVARCHAR(50) NOT NULL,
   e_resid BIGINT NOT NULL,
   e_sub_ident NVARCHAR(2048),
   e_sub_ident2 NVARCHAR(2048),
   e_series_key BIGINT,
   e_series_index INT,
   fk_form_entry BIGINT NOT NULL,
   fk_series_previous BIGINT,
   PRIMARY KEY (id)
);

-- Check and create o_eva_form_participation table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_eva_form_participation' AND xtype='U')
CREATE TABLE o_eva_form_participation (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   e_identifier_type NVARCHAR(50) NOT NULL,
   e_identifier_key NVARCHAR(50) NOT NULL,
   e_status NVARCHAR(20) NOT NULL,
   e_anonymous BIT NOT NULL,  -- Changed BOOL to BIT
   fk_executor BIGINT,
   fk_survey BIGINT,
   PRIMARY KEY (id)
);

-- Check and create o_eva_form_session table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_eva_form_session' AND xtype='U')
CREATE TABLE o_eva_form_session (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   e_status NVARCHAR(16),
   e_submission_date DATETIME2,
   e_first_submission_date DATETIME2,
   e_email NVARCHAR(1024),
   e_firstname NVARCHAR(1024),
   e_lastname NVARCHAR(1024),
   e_age NVARCHAR(1024),
   e_gender NVARCHAR(1024),
   e_org_unit NVARCHAR(1024),
   e_study_subject NVARCHAR(1024),
   fk_survey BIGINT,
   fk_participation BIGINT UNIQUE,
   fk_identity BIGINT,
   fk_page_body BIGINT,
   fk_form_entry BIGINT,
   PRIMARY KEY (id)
);

-- Check and create o_eva_form_response table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_eva_form_response' AND xtype='U')
CREATE TABLE o_eva_form_response (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   e_no_response BIT DEFAULT 0,  -- Changed BOOL to BIT
   e_responseidentifier NVARCHAR(64) NOT NULL,
   e_numericalresponse DECIMAL(38,10) DEFAULT NULL,  -- Changed from DECIMAL(65,10) to DECIMAL(38,10)
   e_stringuifiedresponse NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
   e_file_response_path NVARCHAR(4000),
   fk_session BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_qual_data_collection table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_qual_data_collection' AND xtype='U')
CREATE TABLE o_qual_data_collection (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   q_status NVARCHAR(50),
   q_title NVARCHAR(200),
   q_start DATETIME2,
   q_deadline DATETIME2,
   q_qualitative_feedback BIT DEFAULT 0 NOT NULL,  -- Changed BOOL to BIT
   q_topic_type NVARCHAR(50),
   q_topic_custom NVARCHAR(200),
   q_topic_fk_identity BIGINT,
   q_topic_fk_organisation BIGINT,
   q_topic_fk_curriculum BIGINT,
   q_topic_fk_curriculum_element BIGINT,
   q_topic_fk_repository BIGINT,
   fk_generator BIGINT,
   q_generator_provider_key BIGINT,
   PRIMARY KEY (id)
);

-- Check and create o_qual_data_collection_to_org table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_qual_data_collection_to_org' AND xtype='U')
CREATE TABLE o_qual_data_collection_to_org (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   fk_data_collection BIGINT NOT NULL,
   fk_organisation BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_qual_context table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_qual_context' AND xtype='U')
CREATE TABLE o_qual_context (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   q_role NVARCHAR(20),
   q_location NVARCHAR(1024),
   fk_data_collection BIGINT NOT NULL,
   fk_eva_participation BIGINT,
   fk_eva_session BIGINT,
   fk_audience_repository BIGINT,
   fk_audience_cur_element BIGINT,
   PRIMARY KEY (id)
);

-- Check and create o_qual_context_to_organisation table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_qual_context_to_organisation' AND xtype='U')
CREATE TABLE o_qual_context_to_organisation (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   fk_context BIGINT NOT NULL,
   fk_organisation BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_qual_context_to_curriculum table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_qual_context_to_curriculum' AND xtype='U')
CREATE TABLE o_qual_context_to_curriculum (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   fk_context BIGINT NOT NULL,
   fk_curriculum BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_qual_context_to_cur_element table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_qual_context_to_cur_element' AND xtype='U')
CREATE TABLE o_qual_context_to_cur_element (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   fk_context BIGINT NOT NULL,
   fk_cur_element BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_qual_context_to_tax_level table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_qual_context_to_tax_level' AND xtype='U')
CREATE TABLE o_qual_context_to_tax_level (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   fk_context BIGINT NOT NULL,
   fk_tax_level BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_qual_reminder table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_qual_reminder' AND xtype='U')
CREATE TABLE o_qual_reminder (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   q_type NVARCHAR(65) NOT NULL,
   q_send_planed DATETIME2,
   q_send_done DATETIME2,
   fk_data_collection BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_qual_report_access table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_qual_report_access' AND xtype='U')
CREATE TABLE o_qual_report_access (
  id BIGINT NOT NULL IDENTITY(1,1),
  creationdate DATETIME2 NOT NULL,
  lastmodified DATETIME2 NOT NULL,
  q_type NVARCHAR(64),
  q_role NVARCHAR(64),
  q_online BIT DEFAULT 0,  -- Changed BOOL to BIT
  q_email_trigger NVARCHAR(64),
  q_qualitative_feedback_email BIT DEFAULT 0 NOT NULL,  -- Changed BOOL to BIT
  fk_data_collection BIGINT,
  fk_generator BIGINT,
  fk_group BIGINT,
  PRIMARY KEY (id)
);

-- Check and create o_qual_generator table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_qual_generator' AND xtype='U')
CREATE TABLE o_qual_generator (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   q_title NVARCHAR(256),
   q_type NVARCHAR(64) NOT NULL,
   q_enabled BIT NOT NULL,  -- Changed BOOL to BIT
   q_last_run DATETIME2,
   fk_form_entry BIGINT,
   PRIMARY KEY (id)
);

-- Check and create o_qual_generator_config table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_qual_generator_config' AND xtype='U')
CREATE TABLE o_qual_generator_config (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   q_identifier NVARCHAR(50) NOT NULL,
   q_value NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
   fk_generator BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_qual_generator_to_org table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_qual_generator_to_org' AND xtype='U')
CREATE TABLE o_qual_generator_to_org (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   fk_generator BIGINT NOT NULL,
   fk_organisation BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_qual_generator_override table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_qual_generator_override' AND xtype='U')
CREATE TABLE o_qual_generator_override (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   q_identifier NVARCHAR(512) NOT NULL,
   q_start DATETIME2,
   q_generator_provider_key BIGINT,
   fk_generator BIGINT NOT NULL,
   fk_data_collection BIGINT,
   PRIMARY KEY (id)
);

-- Check and create o_qual_analysis_presentation table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_qual_analysis_presentation' AND xtype='U')
CREATE TABLE o_qual_analysis_presentation (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   q_name NVARCHAR(256),
   q_analysis_segment NVARCHAR(100),
   q_search_params NVARCHAR(MAX),  -- Changed TEXT to NVARCHAR(MAX)
   q_heatmap_grouping NVARCHAR(MAX),  -- Changed TEXT to NVARCHAR(MAX)
   q_heatmap_insufficient_only BIT DEFAULT 0,  -- Changed BOOLEAN to BIT
   q_temporal_grouping NVARCHAR(50),
   q_trend_difference NVARCHAR(50),
   q_rubric_id NVARCHAR(50),
   fk_form_entry BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_qual_audit_log table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_qual_audit_log' AND xtype='U')
CREATE TABLE o_qual_audit_log (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   q_action NVARCHAR(32) NOT NULL,
   q_before NVARCHAR(MAX),  -- Changed LONGTEXT to NVARCHAR(MAX)
   q_after NVARCHAR(MAX),  -- Changed LONGTEXT to NVARCHAR(MAX)
   fk_doer BIGINT NOT NULL,
   fk_data_collection BIGINT,
   fk_todo_task BIGINT,
   fk_identity BIGINT,
   PRIMARY KEY (id)
);

-- Check and create o_lti_outcome table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_lti_outcome' AND xtype='U')
CREATE TABLE o_lti_outcome (
   id BIGINT NOT NULL,
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   r_ressubpath NVARCHAR(2048),
   r_action NVARCHAR(255) NOT NULL,
   r_outcome_key NVARCHAR(255) NOT NULL,
   r_outcome_value NVARCHAR(2048),
   fk_resource_id BIGINT NOT NULL,
   fk_identity_id BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_lti_tool table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_lti_tool' AND xtype='U')
CREATE TABLE o_lti_tool (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   l_tool_type NVARCHAR(16) DEFAULT 'EXTERNAL' NOT NULL,
   l_tool_url NVARCHAR(2000) NOT NULL,
   l_tool_name NVARCHAR(255) NOT NULL,
   l_client_id NVARCHAR(128) NOT NULL,
   l_public_key NVARCHAR(MAX),  -- Changed TEXT to NVARCHAR(MAX)
   l_public_key_url NVARCHAR(2000),
   l_public_key_type NVARCHAR(16),
   l_initiate_login_url NVARCHAR(2000),
   l_redirect_url NVARCHAR(2000),
   l_deep_linking BIT,  -- Changed BOOL to BIT
   PRIMARY KEY (id)
);

-- eight round
-- Check and create o_lti_tool_deployment table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_lti_tool_deployment' AND xtype='U')
CREATE TABLE o_lti_tool_deployment (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   l_deployment_id NVARCHAR(128) NOT NULL UNIQUE,
   l_deployment_type NVARCHAR(32),
   l_context_id NVARCHAR(255),
   l_deployment_resource_id NVARCHAR(255),
   l_target_url NVARCHAR(1024),
   l_send_attributes NVARCHAR(2048),
   l_send_custom_attributes NVARCHAR(MAX),  -- Changed TEXT to NVARCHAR(MAX)
   l_author_roles NVARCHAR(2048),
   l_coach_roles NVARCHAR(2048),
   l_participant_roles NVARCHAR(2048),
   l_assessable BIT DEFAULT 0 NOT NULL,  -- Changed BOOL to BIT
   l_nrps BIT DEFAULT 1 NOT NULL,  -- Changed BOOL to BIT
   l_display NVARCHAR(32),
   l_display_height NVARCHAR(32),
   l_display_width NVARCHAR(32),
   l_skip_launch_page BIT DEFAULT 0 NOT NULL,  -- Changed BOOL to BIT
   fk_tool_id BIGINT NOT NULL,
   fk_entry_id BIGINT,
   l_sub_ident NVARCHAR(64),
   fk_group_id BIGINT,
   PRIMARY KEY (id)
);

-- Check and create o_lti_context table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_lti_context' AND xtype='U')
CREATE TABLE o_lti_context (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   l_context_id NVARCHAR(255) NOT NULL,
   l_resource_id NVARCHAR(255),
   l_target_url NVARCHAR(1024),
   l_send_attributes NVARCHAR(2048),
   l_send_custom_attributes NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
   l_author_roles NVARCHAR(2048),
   l_coach_roles NVARCHAR(2048),
   l_participant_roles NVARCHAR(2048),
   l_assessable BIT DEFAULT 0 NOT NULL,  -- Changed BOOL to BIT
   l_nrps BIT DEFAULT 1 NOT NULL,  -- Changed BOOL to BIT
   l_display NVARCHAR(32),
   l_display_height NVARCHAR(32),
   l_display_width NVARCHAR(32),
   l_skip_launch_page BIT DEFAULT 0 NOT NULL,  -- Changed BOOL to BIT
   fk_entry_id BIGINT,
   l_sub_ident NVARCHAR(64),
   fk_group_id BIGINT,
   fk_deployment_id BIGINT,
   PRIMARY KEY (id)
);

-- Check and create o_lti_platform table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_lti_platform' AND xtype='U')
CREATE TABLE o_lti_platform (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   l_name NVARCHAR(255),
   l_mail_matching BIT DEFAULT 0 NOT NULL,  -- Changed BOOL to BIT
   l_scope NVARCHAR(32) DEFAULT 'SHARED' NOT NULL,
   l_issuer NVARCHAR(255) NOT NULL,
   l_client_id NVARCHAR(128) NOT NULL,
   l_key_id NVARCHAR(64) NOT NULL,
   l_public_key NVARCHAR(MAX) NOT NULL,  -- Changed TEXT to NVARCHAR(MAX)
   l_private_key NVARCHAR(MAX) NOT NULL,  -- Changed TEXT to NVARCHAR(MAX)
   l_authorization_uri NVARCHAR(2000),
   l_token_uri NVARCHAR(2000),
   l_jwk_set_uri NVARCHAR(2000),
   PRIMARY KEY (id)
);

-- Check and create o_lti_shared_tool_deployment table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_lti_shared_tool_deployment' AND xtype='U')
CREATE TABLE o_lti_shared_tool_deployment (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   l_deployment_id NVARCHAR(255),
   fk_platform_id BIGINT,
   fk_entry_id BIGINT,
   fk_group_id BIGINT,
   PRIMARY KEY (id)
);

-- Check and create o_lti_shared_tool_service table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_lti_shared_tool_service' AND xtype='U')
CREATE TABLE o_lti_shared_tool_service (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   l_context_id NVARCHAR(255),
   l_service_type NVARCHAR(16) NOT NULL,
   l_service_endpoint NVARCHAR(255) NOT NULL,
   fk_deployment_id BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_lti_content_item table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_lti_content_item' AND xtype='U')
CREATE TABLE o_lti_content_item (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   l_type NVARCHAR(32) NOT NULL,
   l_url NVARCHAR(1024),
   l_title NVARCHAR(255),
   l_text NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
   l_media_type NVARCHAR(255),
   l_html NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
   l_width BIGINT,
   l_height BIGINT,
   l_icon_url NVARCHAR(1024),
   l_icon_height BIGINT,
   l_icon_width BIGINT,
   l_thumbnail_url NVARCHAR(1024),
   l_thumbnail_height BIGINT,
   l_thumbnail_width BIGINT,
   l_presentation NVARCHAR(64),
   l_window_targetname NVARCHAR(1024),
   l_window_width BIGINT,
   l_window_height BIGINT,
   l_window_features NVARCHAR(2048),
   l_iframe_width BIGINT,
   l_iframe_height BIGINT,
   l_iframe_src NVARCHAR(1024),
   l_custom NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
   l_lineitem_label NVARCHAR(1024),
   l_lineitem_score_maximum DECIMAL(38,30),  -- Changed from FLOAT(65,30) to DECIMAL(38,30)
   l_lineitem_resource_id NVARCHAR(1024),
   l_lineitem_tag NVARCHAR(1024),
   l_lineitem_grades_release BIT,  -- Changed BOOL to BIT
   l_available_start DATETIME2,
   l_available_end DATETIME2,
   l_submission_start DATETIME2,
   l_submission_end DATETIME2,
   l_expires_at DATETIME2,
   fk_tool_id BIGINT NOT NULL,
   fk_tool_deployment_id BIGINT,
   fk_context_id BIGINT, 
   PRIMARY KEY (id)
);

-- Check and create o_lti_key table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_lti_key' AND xtype='U')
CREATE TABLE o_lti_key (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   l_key_id NVARCHAR(255),
   l_public_key NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
   l_private_key NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
   l_algorithm NVARCHAR(64) NOT NULL,
   l_issuer NVARCHAR(1024) NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_cl_checkbox table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_cl_checkbox' AND xtype='U')
CREATE TABLE o_cl_checkbox (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   c_checkboxid NVARCHAR(50) NOT NULL,
   c_resname NVARCHAR(50) NOT NULL,
   c_resid BIGINT NOT NULL,
   c_ressubpath NVARCHAR(255) NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_cl_check table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_cl_check' AND xtype='U')
CREATE TABLE o_cl_check (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   c_score DECIMAL(38,30),  -- Changed from FLOAT(65,30) to DECIMAL(38,30)
   c_checked BIT DEFAULT NULL,  -- Changed BOOL to BIT
   fk_identity_id BIGINT NOT NULL,
   fk_checkbox_id BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_gta_task_list table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_gta_task_list' AND xtype='U')
CREATE TABLE o_gta_task_list (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   g_course_node_ident NVARCHAR(36),
   fk_entry BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_gta_task table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_gta_task' AND xtype='U')
CREATE TABLE o_gta_task (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   g_status NVARCHAR(36),
   g_rev_loop INT NOT NULL DEFAULT 0,  -- Changed MEDIUMINT to INT
   g_assignment_date DATETIME2,
   g_submission_date DATETIME2,
   g_submission_ndocs BIGINT,
   g_submission_drole NVARCHAR(16),
   g_submission_revisions_date DATETIME2,
   g_submission_revisions_ndocs BIGINT,
   g_submission_revisions_drole NVARCHAR(16),
   g_collection_date DATETIME2,
   g_collection_ndocs BIGINT,
   g_collection_revisions_date DATETIME2,
   g_collection_revisions_ndocs BIGINT,
   g_acceptation_date DATETIME2,
   g_solution_date DATETIME2,
   g_graduation_date DATETIME2,
   g_allow_reset_date DATETIME2,
   g_assignment_due_date DATETIME2,
   g_submission_due_date DATETIME2,
   g_revisions_due_date DATETIME2,
   g_solution_due_date DATETIME2,
   g_taskname NVARCHAR(1024),
   fk_tasklist BIGINT NOT NULL,
   fk_identity BIGINT,
   fk_businessgroup BIGINT,
   fk_allow_reset_identity BIGINT,
   PRIMARY KEY (id)
);

-- Check and create o_gta_task_revision table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_gta_task_revision' AND xtype='U')
CREATE TABLE o_gta_task_revision (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   g_status NVARCHAR(36) NOT NULL,
   g_rev_loop INT NOT NULL DEFAULT 0,  -- Changed MEDIUMINT to INT
   g_date DATETIME2,
   g_rev_comment NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
   g_rev_comment_lastmodified DATETIME2,
   fk_task BIGINT NOT NULL,
   fk_comment_author BIGINT,
   PRIMARY KEY (id)
);

-- Check and create o_gta_task_revision_date table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_gta_task_revision_date' AND xtype='U')
CREATE TABLE o_gta_task_revision_date (
  id BIGINT NOT NULL IDENTITY(1,1),
  creationdate DATETIME2 NOT NULL,
  g_status NVARCHAR(36) NOT NULL,
  g_rev_loop BIGINT NOT NULL,
  g_date DATETIME2 NOT NULL,
  fk_task BIGINT NOT NULL,
  PRIMARY KEY (id)
);

-- Check and create o_gta_mark table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_gta_mark' AND xtype='U')
CREATE TABLE o_gta_mark (
  id BIGINT NOT NULL IDENTITY(1,1),
  creationdate DATETIME2 NOT NULL,
  lastmodified DATETIME2 NOT NULL,
  fk_tasklist_id BIGINT NOT NULL,
  fk_marker_identity_id BIGINT NOT NULL,
  fk_participant_identity_id BIGINT NOT NULL,
  PRIMARY KEY (id)
);

-- Check and create o_rem_reminder table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_rem_reminder' AND xtype='U')
CREATE TABLE o_rem_reminder (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   r_description NVARCHAR(255),
   r_start DATETIME2,
   r_sendtime NVARCHAR(16),
   r_configuration NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
   r_email_subject NVARCHAR(255),
   r_email_body NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
   r_email_copy NVARCHAR(32),
   r_email_custom_copy NVARCHAR(1024),
   fk_creator BIGINT NOT NULL,
   fk_entry BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_rem_sent_reminder table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_rem_sent_reminder' AND xtype='U')
CREATE TABLE o_rem_sent_reminder (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   r_status NVARCHAR(16),
   r_run BIGINT DEFAULT 1 NOT NULL,
   fk_identity BIGINT NOT NULL,
   fk_reminder BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_ex_task table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_ex_task' AND xtype='U')
CREATE TABLE o_ex_task (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   e_name NVARCHAR(255) NOT NULL,
   e_status NVARCHAR(16) NOT NULL,
   e_status_before_edit NVARCHAR(16),
   e_executor_node NVARCHAR(16),
   e_executor_boot_id NVARCHAR(64),
   e_task NVARCHAR(MAX) NOT NULL,  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
   e_scheduled DATETIME2,
   e_ressubpath NVARCHAR(2048),
   e_progress DECIMAL(38,30),  -- Changed from FLOAT(65,30) to DECIMAL(38,30)
   e_checkpoint NVARCHAR(255),
   fk_resource_id BIGINT,
   fk_identity_id BIGINT,
   PRIMARY KEY (id)
);

-- Check and create o_ex_task_modifier table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_ex_task_modifier' AND xtype='U')
CREATE TABLE o_ex_task_modifier (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   fk_task_id BIGINT NOT NULL,
   fk_identity_id BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_sms_message_log table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_sms_message_log' AND xtype='U')
CREATE TABLE o_sms_message_log (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   s_message_uuid NVARCHAR(256) NOT NULL,
   s_server_response NVARCHAR(256),
   s_service_id NVARCHAR(32) NOT NULL,
   fk_identity BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_feed table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_feed' AND xtype='U')
CREATE TABLE o_feed (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   f_resourceable_id BIGINT,
   f_resourceable_type NVARCHAR(64),
   f_title NVARCHAR(1024),
   f_description NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
   f_author NVARCHAR(255),
   f_image_name NVARCHAR(1024),
   f_external BIT,  -- Changed BOOLEAN to BIT
   f_external_feed_url NVARCHAR(4000),
   f_external_image_url NVARCHAR(4000),
   PRIMARY KEY (id)
);

-- Check and create o_feed_item table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_feed_item' AND xtype='U')
CREATE TABLE o_feed_item (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   f_title NVARCHAR(1024),
   f_description NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
   f_content NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
   f_author NVARCHAR(255),
   f_guid NVARCHAR(255),
   f_external_link NVARCHAR(4000),
   f_draft BIT,  -- Changed BOOLEAN to BIT
   f_publish_date DATETIME2,
   f_width BIGINT,
   f_height BIGINT,
   f_filename NVARCHAR(1024),
   f_type NVARCHAR(255),
   f_length BIGINT,
   f_external_url NVARCHAR(4000),
   fk_feed_id BIGINT NOT NULL,
   fk_identity_author_id BIGINT,
   fk_identity_modified_id BIGINT,
   PRIMARY KEY (id)
);

-- Check and create o_lecture_reason table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_lecture_reason' AND xtype='U')
CREATE TABLE o_lecture_reason (
  id BIGINT NOT NULL IDENTITY(1,1),
  creationdate DATETIME2 NOT NULL,
  lastmodified DATETIME2 NOT NULL,
  l_enabled BIT DEFAULT 1 NOT NULL,  -- Changed BOOL to BIT
  l_title NVARCHAR(255),
  l_descr NVARCHAR(MAX),  -- Changed LONGTEXT to NVARCHAR(MAX)
  PRIMARY KEY (id)
);

-- Check and create o_lecture_absence_category table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_lecture_absence_category' AND xtype='U')
CREATE TABLE o_lecture_absence_category (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   l_enabled BIT DEFAULT 1 NOT NULL,  -- Changed BOOL to BIT
   l_title NVARCHAR(255),
   l_descr NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
   PRIMARY KEY (id)
);

-- Check and create o_lecture_absence_notice table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_lecture_absence_notice' AND xtype='U')
CREATE TABLE o_lecture_absence_notice (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   l_type NVARCHAR(32),
   l_absence_reason NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
   l_absence_authorized BIT DEFAULT NULL,  -- Changed BOOLEAN to BIT
   l_start_date DATETIME2 NOT NULL,
   l_end_date DATETIME2 NOT NULL,
   l_target NVARCHAR(32) DEFAULT 'allentries' NOT NULL,
   l_attachments_dir NVARCHAR(255),
   fk_identity BIGINT NOT NULL,
   fk_notifier BIGINT,
   fk_authorizer BIGINT,
   fk_absence_category BIGINT,
   PRIMARY KEY (id)
);

-- Check and create o_lecture_block table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_lecture_block' AND xtype='U')
CREATE TABLE o_lecture_block (
  id BIGINT NOT NULL IDENTITY(1,1),
  creationdate DATETIME2 NOT NULL,
  lastmodified DATETIME2 NOT NULL,
  l_external_id NVARCHAR(255),
  l_managed_flags NVARCHAR(255),
  l_title NVARCHAR(255),
  l_descr NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
  l_preparation NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
  l_location NVARCHAR(255),
  l_comment NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
  l_start_date DATETIME2 NOT NULL,
  l_end_date DATETIME2 NOT NULL,
  l_compulsory BIT DEFAULT 1,  -- Changed BOOLEAN to BIT
  l_eff_end_date DATETIME2,
  l_planned_lectures_num BIGINT NOT NULL DEFAULT 0,
  l_effective_lectures_num BIGINT NOT NULL DEFAULT 0,
  l_effective_lectures NVARCHAR(128),
  l_auto_close_date DATETIME2 DEFAULT NULL,
  l_status NVARCHAR(16) NOT NULL,
  l_roll_call_status NVARCHAR(16) NOT NULL,
  fk_reason BIGINT,
  fk_entry BIGINT NOT NULL,
  fk_teacher_group BIGINT NOT NULL,
  PRIMARY KEY (id)
);

-- Check and create o_lecture_block_to_group table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_lecture_block_to_group' AND xtype='U')
CREATE TABLE o_lecture_block_to_group (
  id BIGINT NOT NULL IDENTITY(1,1),
  fk_lecture_block BIGINT NOT NULL,
  fk_group BIGINT NOT NULL,
  PRIMARY KEY (id)
);

-- Check and create o_lecture_notice_to_block table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_lecture_notice_to_block' AND xtype='U')
CREATE TABLE o_lecture_notice_to_block (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   fk_lecture_block BIGINT NOT NULL,
   fk_absence_notice BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_lecture_notice_to_entry table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_lecture_notice_to_entry' AND xtype='U')
CREATE TABLE o_lecture_notice_to_entry (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   fk_entry BIGINT NOT NULL,
   fk_absence_notice BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_lecture_block_roll_call table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_lecture_block_roll_call' AND xtype='U')
CREATE TABLE o_lecture_block_roll_call (
  id BIGINT NOT NULL IDENTITY(1,1),
  creationdate DATETIME2 NOT NULL,
  lastmodified DATETIME2 NOT NULL,
  l_comment NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
  l_lectures_attended NVARCHAR(128),
  l_lectures_absent NVARCHAR(128),
  l_lectures_attended_num BIGINT NOT NULL DEFAULT 0,
  l_lectures_absent_num BIGINT NOT NULL DEFAULT 0,
  l_absence_notice_lectures NVARCHAR(128),
  l_absence_reason NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
  l_absence_authorized BIT DEFAULT NULL,  -- Changed BOOLEAN to BIT
  l_absence_appeal_date DATETIME2,
  l_absence_supervisor_noti_date DATETIME2,
  l_appeal_reason NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
  l_appeal_status NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
  l_appeal_status_reason NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
  fk_lecture_block BIGINT NOT NULL,
  fk_identity BIGINT NOT NULL,
  fk_absence_category BIGINT,
  fk_absence_notice BIGINT,
  PRIMARY KEY (id)
);

-- Check and create o_lecture_reminder table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_lecture_reminder' AND xtype='U')
CREATE TABLE o_lecture_reminder (
  id BIGINT NOT NULL IDENTITY(1,1),
  creationdate DATETIME2 NOT NULL,
  l_status NVARCHAR(16) NOT NULL,
  fk_lecture_block BIGINT NOT NULL,
  fk_identity BIGINT NOT NULL,
  PRIMARY KEY (id)
);


--nineth round
-- Check and create o_lecture_participant_summary table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_lecture_participant_summary' AND xtype='U')
CREATE TABLE o_lecture_participant_summary (
  id BIGINT NOT NULL IDENTITY(1,1),
  creationdate DATETIME2 NOT NULL,
  lastmodified DATETIME2 NOT NULL,
  l_first_admission_date DATETIME2 DEFAULT NULL,
  l_required_attendance_rate DECIMAL(38,30) DEFAULT NULL,  -- Changed FLOAT(65,30) to DECIMAL(38,30)
  l_attended_lectures BIGINT NOT NULL DEFAULT 0,
  l_absent_lectures BIGINT NOT NULL DEFAULT 0,
  l_excused_lectures BIGINT NOT NULL DEFAULT 0,
  l_planneds_lectures BIGINT NOT NULL DEFAULT 0,
  l_attendance_rate DECIMAL(38,30) DEFAULT NULL,  -- Changed FLOAT(65,30) to DECIMAL(38,30)
  l_cal_sync BIT DEFAULT 0,
  l_cal_last_sync_date DATETIME2 DEFAULT NULL,
  fk_entry BIGINT NOT NULL,
  fk_identity BIGINT NOT NULL,
  PRIMARY KEY (id),
  UNIQUE (fk_entry, fk_identity)
);

-- Check and create o_lecture_entry_config table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_lecture_entry_config' AND xtype='U')
CREATE TABLE o_lecture_entry_config (
  id BIGINT NOT NULL IDENTITY(1,1),
  creationdate DATETIME2 NOT NULL,
  lastmodified DATETIME2 NOT NULL,
  l_lecture_enabled BIT DEFAULT NULL,
  l_override_module_def BIT DEFAULT 0,
  l_rollcall_enabled BIT DEFAULT NULL,
  l_calculate_attendance_rate BIT DEFAULT NULL,
  l_required_attendance_rate DECIMAL(38,30) DEFAULT NULL,  -- Changed FLOAT(65,30) to DECIMAL(38,30)
  l_sync_calendar_teacher BIT DEFAULT NULL,
  l_sync_calendar_participant BIT DEFAULT NULL,
  l_sync_calendar_course BIT DEFAULT NULL,
  l_assessment_mode BIT DEFAULT NULL,
  l_assessment_mode_lead BIGINT DEFAULT NULL,
  l_assessment_mode_followup BIGINT DEFAULT NULL,
  l_assessment_mode_ips NVARCHAR(2048),
  l_assessment_mode_seb NVARCHAR(2048),
  fk_entry BIGINT NOT NULL,
  UNIQUE(fk_entry),
  PRIMARY KEY (id)
);

-- Check and create o_lecture_block_audit_log table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_lecture_block_audit_log' AND xtype='U')
CREATE TABLE o_lecture_block_audit_log (
  id BIGINT NOT NULL IDENTITY(1,1),
  creationdate DATETIME2 NOT NULL,
  l_action NVARCHAR(32),
  l_val_before NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
  l_val_after NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
  l_message NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
  fk_lecture_block BIGINT,
  fk_roll_call BIGINT,
  fk_absence_notice BIGINT,
  fk_entry BIGINT,
  fk_identity BIGINT,
  fk_author BIGINT,
  PRIMARY KEY (id)
);

-- Check and create o_lecture_block_to_tax_level table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_lecture_block_to_tax_level' AND xtype='U')
CREATE TABLE o_lecture_block_to_tax_level (
  id BIGINT NOT NULL IDENTITY(1,1),
  creationdate DATETIME2 NOT NULL,
  fk_lecture_block BIGINT NOT NULL,
  fk_taxonomy_level BIGINT NOT NULL,
  PRIMARY KEY (id)
);

-- Check and create o_tax_taxonomy table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_tax_taxonomy' AND xtype='U')
CREATE TABLE o_tax_taxonomy (
  id BIGINT NOT NULL IDENTITY(1,1),
  creationdate DATETIME2 NOT NULL,
  lastmodified DATETIME2 NOT NULL,
  t_identifier NVARCHAR(64),
  t_displayname NVARCHAR(255) NOT NULL,
  t_description NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
  t_external_id NVARCHAR(64),
  t_managed_flags NVARCHAR(255),
  t_directory_path NVARCHAR(255),
  t_directory_lost_found_path NVARCHAR(255),
  fk_group BIGINT NOT NULL,
  PRIMARY KEY (id)
);

-- Check and create o_tax_taxonomy_level_type table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_tax_taxonomy_level_type' AND xtype='U')
CREATE TABLE o_tax_taxonomy_level_type (
  id BIGINT NOT NULL IDENTITY(1,1),
  creationdate DATETIME2 NOT NULL,
  lastmodified DATETIME2 NOT NULL,
  t_identifier NVARCHAR(64),
  t_displayname NVARCHAR(255) NOT NULL,
  t_description NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
  t_external_id NVARCHAR(64),
  t_managed_flags NVARCHAR(255),
  t_css_class NVARCHAR(64),
  t_visible BIT DEFAULT 1,
  t_library_docs BIT DEFAULT 1,
  t_library_manage BIT DEFAULT 1,
  t_library_teach_read BIT DEFAULT 1,
  t_library_teach_readlevels BIGINT NOT NULL DEFAULT 0,
  t_library_teach_write BIT DEFAULT 0,
  t_library_have_read BIT DEFAULT 1,
  t_library_target_read BIT DEFAULT 1,
  t_allow_as_competence BIT DEFAULT 1 NOT NULL,
  t_allow_as_subject BIT DEFAULT 0,
  fk_taxonomy BIGINT NOT NULL,
  PRIMARY KEY (id)
);

-- Check and create o_tax_taxonomy_type_to_type table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_tax_taxonomy_type_to_type' AND xtype='U')
CREATE TABLE o_tax_taxonomy_type_to_type (
  id BIGINT NOT NULL IDENTITY(1,1),
  fk_type BIGINT NOT NULL,
  fk_allowed_sub_type BIGINT NOT NULL,
  PRIMARY KEY (id)
);

-- Check and create o_tax_taxonomy_level table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_tax_taxonomy_level' AND xtype='U')
CREATE TABLE o_tax_taxonomy_level (
  id BIGINT NOT NULL IDENTITY(1,1),
  creationdate DATETIME2 NOT NULL,
  lastmodified DATETIME2 NOT NULL,
  t_identifier NVARCHAR(255),
  t_i18n_suffix NVARCHAR(64),
  t_displayname NVARCHAR(255),
  t_description NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
  t_external_id NVARCHAR(64),
  t_sort_order BIGINT,
  t_directory_path NVARCHAR(255),
  t_media_path NVARCHAR(255),
  t_m_path_keys NVARCHAR(255),
  t_m_path_identifiers NVARCHAR(MAX),  -- Changed TEXT to NVARCHAR(MAX)
  t_enabled BIT DEFAULT 1,
  t_managed_flags NVARCHAR(255),
  fk_taxonomy BIGINT NOT NULL,
  fk_parent BIGINT,
  fk_type BIGINT,
  PRIMARY KEY (id)
);

-- Check and create o_tax_taxonomy_competence table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_tax_taxonomy_competence' AND xtype='U')
CREATE TABLE o_tax_taxonomy_competence (
  id BIGINT NOT NULL IDENTITY(1,1),
  creationdate DATETIME2 NOT NULL,
  lastmodified DATETIME2 NOT NULL,
  t_type NVARCHAR(16),
  t_achievement DECIMAL(38,30) DEFAULT NULL,  -- Changed FLOAT(65,30) to DECIMAL(38,30)
  t_reliability DECIMAL(38,30) DEFAULT NULL,  -- Changed FLOAT(65,30) to DECIMAL(38,30)
  t_expiration_date DATETIME2,
  t_external_id NVARCHAR(64),
  t_source_text NVARCHAR(255),
  t_source_url NVARCHAR(255),
  t_link_location NVARCHAR(255) DEFAULT 'UNDEFINED' NOT NULL,
  fk_level BIGINT NOT NULL,
  fk_identity BIGINT NOT NULL,
  PRIMARY KEY (id)
);

-- Check and create o_tax_competence_audit_log table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_tax_competence_audit_log' AND xtype='U')
CREATE TABLE o_tax_competence_audit_log (
  id BIGINT NOT NULL IDENTITY(1,1),
  creationdate DATETIME2 NOT NULL,
  t_action NVARCHAR(32),
  t_val_before NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
  t_val_after NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
  t_message NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
  fk_taxonomy BIGINT,
  fk_taxonomy_competence BIGINT,
  fk_identity BIGINT,
  fk_author BIGINT,
  PRIMARY KEY (id)
);

-- Check and create o_dialog_element table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_dialog_element' AND xtype='U')
CREATE TABLE o_dialog_element (
  id BIGINT NOT NULL IDENTITY(1,1),
  creationdate DATETIME2 NOT NULL,
  lastmodified DATETIME2 NOT NULL,
  d_filename NVARCHAR(2048),
  d_filesize BIGINT,
  d_subident NVARCHAR(64) NOT NULL,
  d_authoredby NVARCHAR(256),
  fk_author BIGINT,
  fk_entry BIGINT NOT NULL,
  fk_forum BIGINT NOT NULL,
  PRIMARY KEY (id)
);

-- Check and create o_lic_license_type table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_lic_license_type' AND xtype='U')
CREATE TABLE o_lic_license_type (
  id BIGINT NOT NULL IDENTITY(1,1),
  creationdate DATETIME2 NOT NULL,
  lastmodified DATETIME2 NOT NULL,
  l_name NVARCHAR(128) NOT NULL UNIQUE,
  l_text NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
  l_css_class NVARCHAR(64),
  l_predefined BIT NOT NULL DEFAULT 0,  -- Changed BOOLEAN to BIT
  l_sort_order INT NOT NULL,
  l_type_oer BIT NOT NULL DEFAULT 0,  -- Changed BOOLEAN to BIT
  PRIMARY KEY (id)
);

-- Check and create o_lic_license_type_activation table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_lic_license_type_activation' AND xtype='U')
CREATE TABLE o_lic_license_type_activation (
  id BIGINT NOT NULL IDENTITY(1,1),
  creationdate DATETIME2 NOT NULL,
  l_handler_type NVARCHAR(128) NOT NULL,
  fk_license_type_id BIGINT NOT NULL,
  PRIMARY KEY (id)
);

-- Check and create o_lic_license table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_lic_license' AND xtype='U')
CREATE TABLE o_lic_license (
  id BIGINT NOT NULL IDENTITY(1,1),
  creationdate DATETIME2 NOT NULL,
  lastmodified DATETIME2 NOT NULL,
  l_resname NVARCHAR(50) NOT NULL,
  l_resid BIGINT NOT NULL,
  l_licensor NVARCHAR(4000),
  l_freetext NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
  fk_license_type_id BIGINT NOT NULL,
  PRIMARY KEY (id)
);

-- Check and create o_org_organisation_type table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_org_organisation_type' AND xtype='U')
CREATE TABLE o_org_organisation_type (
  id BIGINT NOT NULL IDENTITY(1,1),
  creationdate DATETIME2 NOT NULL,
  lastmodified DATETIME2 NOT NULL,
  o_identifier NVARCHAR(64),
  o_displayname NVARCHAR(255) NOT NULL,
  o_description NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
  o_external_id NVARCHAR(64),
  o_managed_flags NVARCHAR(255),
  o_css_class NVARCHAR(64),
  PRIMARY KEY (id)
);

-- Check and create o_org_organisation table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_org_organisation' AND xtype='U')
CREATE TABLE o_org_organisation (
  id BIGINT NOT NULL IDENTITY(1,1),
  creationdate DATETIME2 NOT NULL,
  lastmodified DATETIME2 NOT NULL,
  o_identifier NVARCHAR(64),
  o_displayname NVARCHAR(255) NOT NULL,
  o_description NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
  o_m_path_keys NVARCHAR(255),
  o_external_id NVARCHAR(64),
  o_managed_flags NVARCHAR(255),
  o_status NVARCHAR(32),
  o_css_class NVARCHAR(64),
  fk_group BIGINT NOT NULL,
  fk_root BIGINT,
  fk_parent BIGINT,
  fk_type BIGINT,
  PRIMARY KEY (id)
);

-- Check and create o_org_type_to_type table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_org_type_to_type' AND xtype='U')
CREATE TABLE o_org_type_to_type (
  id BIGINT NOT NULL IDENTITY(1,1),
  fk_type BIGINT NOT NULL,
  fk_allowed_sub_type BIGINT NOT NULL,
  PRIMARY KEY (id)
);

-- Check and create o_re_to_organisation table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_re_to_organisation' AND xtype='U')
CREATE TABLE o_re_to_organisation (
  id BIGINT NOT NULL IDENTITY(1,1),
  creationdate DATETIME2 NOT NULL,
  lastmodified DATETIME2 NOT NULL,
  r_master BIT DEFAULT 0,
  fk_entry BIGINT NOT NULL,
  fk_organisation BIGINT NOT NULL,
  PRIMARY KEY (id)
);

-- Check and create o_cur_element_type table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_cur_element_type' AND xtype='U')
CREATE TABLE o_cur_element_type (
  id BIGINT NOT NULL IDENTITY(1,1),
  creationdate DATETIME2 NOT NULL,
  lastmodified DATETIME2 NOT NULL,
  c_identifier NVARCHAR(64),
  c_displayname NVARCHAR(255) NOT NULL,
  c_description NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
  c_external_id NVARCHAR(64),
  c_managed_flags NVARCHAR(255),
  c_calendars NVARCHAR(16),
  c_lectures NVARCHAR(16),
  c_learning_progress NVARCHAR(16),
  c_css_class NVARCHAR(64),
  PRIMARY KEY (id)
);

-- Check and create o_cur_curriculum table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_cur_curriculum' AND xtype='U')
CREATE TABLE o_cur_curriculum (
  id BIGINT NOT NULL IDENTITY(1,1),
  creationdate DATETIME2 NOT NULL,
  lastmodified DATETIME2 NOT NULL,
  c_identifier NVARCHAR(64),
  c_displayname NVARCHAR(255) NOT NULL,
  c_description NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
  c_external_id NVARCHAR(64),
  c_managed_flags NVARCHAR(255),
  c_status NVARCHAR(32),
  c_degree NVARCHAR(255),
  c_lectures BIT DEFAULT 0 NOT NULL,  -- Changed BOOLEAN to BIT
  fk_group BIGINT NOT NULL,
  fk_organisation BIGINT,
  PRIMARY KEY (id)
);

-- Check and create o_cur_curriculum_element table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_cur_curriculum_element' AND xtype='U')
CREATE TABLE o_cur_curriculum_element (
  id BIGINT NOT NULL IDENTITY(1,1),
  creationdate DATETIME2 NOT NULL,
  lastmodified DATETIME2 NOT NULL,
  pos BIGINT,
  pos_cur BIGINT,
  c_identifier NVARCHAR(64),
  c_displayname NVARCHAR(255) NOT NULL,
  c_description NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
  c_status NVARCHAR(32),
  c_begin DATETIME2,
  c_end DATETIME2,
  c_external_id NVARCHAR(64),
  c_m_path_keys NVARCHAR(255),
  c_managed_flags NVARCHAR(255),
  c_calendars NVARCHAR(16),
  c_lectures NVARCHAR(16),
  c_learning_progress NVARCHAR(16),
  fk_group BIGINT NOT NULL,
  fk_parent BIGINT,
  fk_curriculum BIGINT NOT NULL,
  fk_curriculum_parent BIGINT,
  fk_type BIGINT,
  PRIMARY KEY (id)
);

-- Check and create o_cur_element_type_to_type table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_cur_element_type_to_type' AND xtype='U')
CREATE TABLE o_cur_element_type_to_type (
  id BIGINT NOT NULL IDENTITY(1,1),
  fk_type BIGINT NOT NULL,
  fk_allowed_sub_type BIGINT NOT NULL,
  PRIMARY KEY (id)
);

-- Check and create o_cur_element_to_tax_level table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_cur_element_to_tax_level' AND xtype='U')
CREATE TABLE o_cur_element_to_tax_level (
  id BIGINT NOT NULL IDENTITY(1,1),
  creationdate DATETIME2 NOT NULL,
  fk_cur_element BIGINT NOT NULL,
  fk_taxonomy_level BIGINT NOT NULL,
  PRIMARY KEY (id)
);

-- Check and create o_es_usage table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_es_usage' AND xtype='U')
CREATE TABLE o_es_usage (
  id BIGINT NOT NULL IDENTITY(1,1),
  creationdate DATETIME2 NOT NULL,
  lastmodified DATETIME2 NOT NULL,
  e_identifier NVARCHAR(64) NOT NULL,
  e_resname NVARCHAR(50) NOT NULL,
  e_resid BIGINT NOT NULL,
  e_sub_path NVARCHAR(256),
  e_object_url NVARCHAR(255) NOT NULL,
  e_version NVARCHAR(64),
  e_mime_type NVARCHAR(128),
  e_media_type NVARCHAR(128),
  e_width NVARCHAR(8),
  e_height NVARCHAR(8),
  fk_identity BIGINT NOT NULL,
  PRIMARY KEY (id)
);

-- Check and create o_livestream_launch table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_livestream_launch' AND xtype='U')
CREATE TABLE o_livestream_launch (
  id BIGINT NOT NULL IDENTITY(1,1),
  creationdate DATETIME2 NOT NULL,
  l_launch_date DATETIME2 NOT NULL,
  fk_entry BIGINT NOT NULL,
  l_subident NVARCHAR(128) NOT NULL,
  fk_identity BIGINT NOT NULL,
  PRIMARY KEY (id)
);

-- Check and create o_livestream_url_template table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_livestream_url_template' AND xtype='U')
CREATE TABLE o_livestream_url_template (
  id BIGINT NOT NULL IDENTITY(1,1),
  creationdate DATETIME2 NOT NULL,
  lastmodified DATETIME2 NOT NULL,
  l_name NVARCHAR(64) NOT NULL,
  l_url1 NVARCHAR(2048),
  l_url2 NVARCHAR(2048),
  PRIMARY KEY (id)
);

-- Check and create o_grad_to_identity table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_grad_to_identity' AND xtype='U')
CREATE TABLE o_grad_to_identity (
  id BIGINT NOT NULL IDENTITY(1,1),
  creationdate DATETIME2 NOT NULL,
  lastmodified DATETIME2 NOT NULL,
  g_status NVARCHAR(16) DEFAULT 'activated' NOT NULL,
  fk_identity BIGINT NOT NULL,
  fk_entry BIGINT NOT NULL,
  PRIMARY KEY (id)
);

-- Check and create o_grad_assignment table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_grad_assignment' AND xtype='U')
CREATE TABLE o_grad_assignment (
  id BIGINT NOT NULL IDENTITY(1,1),
  creationdate DATETIME2 NOT NULL,
  lastmodified DATETIME2 NOT NULL,
  g_status NVARCHAR(16) DEFAULT 'unassigned' NOT NULL,
  g_assessment_date DATETIME2,
  g_assignment_date DATETIME2,
  g_assignment_notification DATETIME2,
  g_reminder_1 DATETIME2,
  g_reminder_2 DATETIME2,
  g_deadline DATETIME2,
  g_extended_deadline DATETIME2,
  g_closed DATETIME2,
  fk_reference_entry BIGINT NOT NULL,
  fk_assessment_entry BIGINT NOT NULL,
  fk_grader BIGINT,
  PRIMARY KEY (id)
);

-- Check and create o_grad_time_record table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_grad_time_record' AND xtype='U')
CREATE TABLE o_grad_time_record (
  id BIGINT NOT NULL IDENTITY(1,1),
  creationdate DATETIME2 NOT NULL,
  lastmodified DATETIME2 NOT NULL,
  g_time BIGINT DEFAULT 0 NOT NULL,
  g_metadata_time BIGINT DEFAULT 0 NOT NULL,
  g_date_record DATE NOT NULL,
  fk_assignment BIGINT,
  fk_grader BIGINT NOT NULL,
  PRIMARY KEY (id)
);

-- Check and create o_grad_configuration table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_grad_configuration' AND xtype='U')
CREATE TABLE o_grad_configuration (
  id BIGINT NOT NULL IDENTITY(1,1),
  creationdate DATETIME2 NOT NULL,
  lastmodified DATETIME2 NOT NULL,
  g_grading_enabled BIT NOT NULL DEFAULT 0,  -- Changed BOOLEAN to BIT
  g_identity_visibility NVARCHAR(32) DEFAULT 'anonymous' NOT NULL,
  g_grading_period BIGINT,
  g_notification_type NVARCHAR(32) DEFAULT 'afterTestSubmission' NOT NULL,
  g_notification_subject NVARCHAR(255),
  g_notification_body NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
  g_first_reminder BIGINT,
  g_first_reminder_subject NVARCHAR(255),
  g_first_reminder_body NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
  g_second_reminder BIGINT,
  g_second_reminder_subject NVARCHAR(255),
  g_second_reminder_body NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
  fk_entry BIGINT NOT NULL,
  PRIMARY KEY (id)
);

-- Check and create o_course_element table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_course_element' AND xtype='U')
CREATE TABLE o_course_element (
  id BIGINT NOT NULL IDENTITY(1,1),
  creationdate DATETIME2 NOT NULL,
  lastmodified DATETIME2 NOT NULL,
  c_type NVARCHAR(32) NOT NULL,
  c_short_title NVARCHAR(32) NOT NULL,
  c_long_title NVARCHAR(1024) NOT NULL,
  c_assesseable BIT NOT NULL,  -- Changed BOOLEAN to BIT
  c_score_mode NVARCHAR(16) NOT NULL,
  c_grade BIT NOT NULL DEFAULT 0,  -- Changed BOOLEAN to BIT
  c_auto_grade BIT NOT NULL DEFAULT 0,  -- Changed BOOLEAN to BIT
  c_passed_mode NVARCHAR(16) NOT NULL,
  c_cut_value DECIMAL(38,30),  -- Changed FLOAT(65,30) to DECIMAL(38,30)
  c_coach_assignment BIT DEFAULT 0 NOT NULL,  -- Changed BOOLEAN to BIT
  fk_entry BIGINT NOT NULL,
  c_subident NVARCHAR(64) NOT NULL,
  PRIMARY KEY (id)
);

-- Check and create o_course_color_category table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_course_color_category' AND xtype='U')
CREATE TABLE o_course_color_category (
  id BIGINT NOT NULL IDENTITY(1,1),
  creationdate DATETIME2 NOT NULL,
  lastmodified DATETIME2 NOT NULL,
  c_identifier NVARCHAR(128) NOT NULL,
  c_type NVARCHAR(16) NOT NULL,
  c_sort_order INT NOT NULL,
  c_enabled BIT NOT NULL DEFAULT 1,  -- Changed BOOLEAN to BIT
  c_css_class NVARCHAR(128),
  PRIMARY KEY (id)
);

-- Check and create o_course_disclaimer_consent table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_course_disclaimer_consent' AND xtype='U')
CREATE TABLE o_course_disclaimer_consent (
  id BIGINT NOT NULL IDENTITY(1,1),
  disc_1_accepted BIT NOT NULL,  -- Changed BOOLEAN to BIT
  disc_2_accepted BIT NOT NULL,  -- Changed BOOLEAN to BIT
  creationdate DATETIME2 NOT NULL,
  lastmodified DATETIME2 NOT NULL,
  fk_repository_entry BIGINT NOT NULL,
  fk_identity BIGINT NOT NULL,
  PRIMARY KEY (id)
);

-- Check and create o_ap_topic table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_ap_topic' AND xtype='U')
CREATE TABLE o_ap_topic (
  id BIGINT NOT NULL IDENTITY(1,1),
  creationdate DATETIME2 NOT NULL,
  lastmodified DATETIME2 NOT NULL,
  a_title NVARCHAR(256),
  a_description NVARCHAR(4000),
  a_type NVARCHAR(64) NOT NULL,
  a_multi_participation BIT DEFAULT 1 NOT NULL,  -- Changed BOOLEAN to BIT
  a_auto_confirmation BIT DEFAULT 0 NOT NULL,  -- Changed BOOLEAN to BIT
  a_participation_visible BIT DEFAULT 1 NOT NULL,  -- Changed BOOLEAN to BIT
  fk_group_id BIGINT,
  fk_entry_id BIGINT NOT NULL,
  a_sub_ident NVARCHAR(64) NOT NULL,
  PRIMARY KEY (id)
);

-- Check and create o_ap_organizer table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_ap_organizer' AND xtype='U')
CREATE TABLE o_ap_organizer (
  id BIGINT NOT NULL IDENTITY(1,1),
  creationdate DATETIME2 NOT NULL,
  lastmodified DATETIME2 NOT NULL,
  fk_topic_id BIGINT NOT NULL,
  fk_identity_id BIGINT NOT NULL,
  PRIMARY KEY (id)
);


--  tenth round

-- Check and create o_ap_topic_to_group table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_ap_topic_to_group' AND xtype='U')
CREATE TABLE o_ap_topic_to_group (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   fk_topic_id BIGINT NOT NULL,
   fk_group_id BIGINT,
   PRIMARY KEY (id)
);

-- Check and create o_ap_appointment table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_ap_appointment' AND xtype='U')
CREATE TABLE o_ap_appointment (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   a_status NVARCHAR(64) NOT NULL,
   a_status_mod_date DATETIME2,
   a_start DATETIME2,
   a_end DATETIME2,
   a_location NVARCHAR(256),
   a_details NVARCHAR(4000),
   a_max_participations INT,
   fk_topic_id BIGINT NOT NULL,
   fk_meeting_id BIGINT,
   fk_teams_id BIGINT,
   PRIMARY KEY (id)
);

-- Check and create o_ap_participation table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_ap_participation' AND xtype='U')
CREATE TABLE o_ap_participation (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   fk_appointment_id BIGINT NOT NULL,
   fk_identity_id BIGINT NOT NULL,
   fk_identity_created_by BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_org_role_to_right table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_org_role_to_right' AND xtype='U')
CREATE TABLE o_org_role_to_right (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   o_role NVARCHAR(255) NOT NULL,
   o_right NVARCHAR(255) NOT NULL,
   fk_organisation BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_ct_location table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_ct_location' AND xtype='U')
CREATE TABLE o_ct_location (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   l_reference NVARCHAR(255),
   l_titel NVARCHAR(255),
   l_room NVARCHAR(255),
   l_sector NVARCHAR(255),
   l_table NVARCHAR(255),
   l_building NVARCHAR(255),
   l_seat_number BIT DEFAULT 0 NOT NULL,
   l_qr_id NVARCHAR(255) NOT NULL UNIQUE,
   l_qr_text NVARCHAR(4000),
   l_guests BIT DEFAULT 1 NOT NULL,
   l_printed BIT DEFAULT 0 NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_ct_registration table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_ct_registration' AND xtype='U')
CREATE TABLE o_ct_registration (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   l_deletion_date DATETIME2 NOT NULL,
   l_start_date DATETIME2 NOT NULL,
   l_end_date DATETIME2,
   l_nick_name NVARCHAR(255),
   l_first_name NVARCHAR(255),
   l_last_name NVARCHAR(255),
   l_street NVARCHAR(255),
   l_extra_line NVARCHAR(255),
   l_zip_code NVARCHAR(255),
   l_city NVARCHAR(255),
   l_email NVARCHAR(255),
   l_institutional_email NVARCHAR(255),
   l_generic_email NVARCHAR(255),
   l_private_phone NVARCHAR(255),
   l_mobile_phone NVARCHAR(255),
   l_office_phone NVARCHAR(255),
   l_seat_number NVARCHAR(64),
   l_immunity_proof_level NVARCHAR(20),
   l_immunity_proof_date DATETIME2,
   fk_location BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_immunity_proof table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_immunity_proof' AND xtype='U')
CREATE TABLE o_immunity_proof (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   fk_user BIGINT NOT NULL,
   safedate DATETIME2 NOT NULL,
   validated BIT NOT NULL,  -- Changed BOOLEAN to BIT
   send_mail BIT NOT NULL,  -- Changed BOOLEAN to BIT
   email_sent BIT NOT NULL DEFAULT 0,  -- Changed BOOLEAN to BIT
   PRIMARY KEY (id)
);

-- Check and create o_zoom_profile table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_zoom_profile' AND xtype='U')
CREATE TABLE o_zoom_profile (
    id BIGINT NOT NULL IDENTITY(1,1),
    creationdate DATETIME2 NOT NULL,
    lastmodified DATETIME2 NOT NULL,
    z_name NVARCHAR(255) NOT NULL,
    z_status NVARCHAR(255) NOT NULL,
    z_lti_key NVARCHAR(255) NOT NULL,
    z_mail_domains NVARCHAR(1024),
    z_students_can_host BIT DEFAULT 0,  -- Changed BOOLEAN to BIT
    z_token NVARCHAR(255) NOT NULL,
    fk_lti_tool_id BIGINT NOT NULL,
    PRIMARY KEY (id)
);

-- Check and create o_zoom_config table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_zoom_config' AND xtype='U')
CREATE TABLE o_zoom_config (
    id BIGINT NOT NULL IDENTITY(1,1),
    creationdate DATETIME2 NOT NULL,
    lastmodified DATETIME2 NOT NULL,
    z_description NVARCHAR(255),
    fk_profile BIGINT NOT NULL,
    fk_lti_tool_deployment_id BIGINT NOT NULL,
    fk_lti_context_id BIGINT,
    PRIMARY KEY (id)
);

-- Check and create o_repositoryentry_audit_log table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_repositoryentry_audit_log' AND xtype='U')
CREATE TABLE o_repositoryentry_audit_log (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   r_action NVARCHAR(32) NOT NULL,
   r_val_before NVARCHAR(MAX),  -- Changed LONGTEXT to NVARCHAR(MAX)
   r_val_after NVARCHAR(MAX),  -- Changed LONGTEXT to NVARCHAR(MAX)
   fk_entry BIGINT,
   fk_author BIGINT,
   PRIMARY KEY (id)
);
CREATE INDEX idx_re_audit_log_to_re_entry_idx ON o_repositoryentry_audit_log (fk_entry);

-- Check and create o_proj_project table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_proj_project' AND xtype='U')
CREATE TABLE o_proj_project (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   p_external_ref NVARCHAR(128),
   p_status NVARCHAR(32),
   p_title NVARCHAR(128),
   p_teaser NVARCHAR(150),
   p_description NVARCHAR(MAX),  -- Changed LONGTEXT to NVARCHAR(MAX)
   p_avatar_css_class NVARCHAR(32),
   p_template_private BIT DEFAULT 0 NOT NULL,  -- Changed BOOLEAN to BIT
   p_template_public BIT DEFAULT 0 NOT NULL,  -- Changed BOOLEAN to BIT
   p_deleted_date DATETIME2,
   fk_deleted_by BIGINT,
   fk_creator BIGINT NOT NULL,
   fk_group BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_proj_project_to_org table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_proj_project_to_org' AND xtype='U')
CREATE TABLE o_proj_project_to_org (
  id BIGINT NOT NULL IDENTITY(1,1),
  creationdate DATETIME2 NOT NULL,
  fk_project BIGINT NOT NULL,
  fk_organisation BIGINT NOT NULL,
  PRIMARY KEY (id)
);

-- Check and create o_proj_template_to_org table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_proj_template_to_org' AND xtype='U')
CREATE TABLE o_proj_template_to_org (
  id BIGINT NOT NULL IDENTITY(1,1),
  creationdate DATETIME2 NOT NULL,
  fk_project BIGINT NOT NULL,
  fk_organisation BIGINT NOT NULL,
  PRIMARY KEY (id)
);

-- Check and create o_proj_project_user_info table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_proj_project_user_info' AND xtype='U')
CREATE TABLE o_proj_project_user_info (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   p_last_visit_date DATETIME2,
   fk_project BIGINT NOT NULL,
   fk_identity BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_proj_artefact table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_proj_artefact' AND xtype='U')
CREATE TABLE o_proj_artefact (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   p_type NVARCHAR(32),
   p_content_modified_date DATETIME2 NOT NULL,
   fk_content_modified_by BIGINT NOT NULL,
   p_deleted_date DATETIME2,
   fk_deleted_by BIGINT,
   p_status NVARCHAR(32),
   fk_project BIGINT NOT NULL,
   fk_creator BIGINT NOT NULL,
   fk_group BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_proj_artefact_to_artefact table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_proj_artefact_to_artefact' AND xtype='U')
CREATE TABLE o_proj_artefact_to_artefact (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   fk_artefact1 BIGINT NOT NULL,
   fk_artefact2 BIGINT NOT NULL,
   fk_project BIGINT NOT NULL,
   fk_creator BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_proj_tag table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_proj_tag' AND xtype='U')
CREATE TABLE o_proj_tag (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   fk_project BIGINT NOT NULL,
   fk_artefact BIGINT,
   fk_tag BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_proj_file table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_proj_file' AND xtype='U')
CREATE TABLE o_proj_file (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   fk_metadata BIGINT NOT NULL,
   fk_artefact BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_proj_todo table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_proj_todo' AND xtype='U')
CREATE TABLE o_proj_todo (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   p_identifier NVARCHAR(64) NOT NULL,
   fk_todo_task BIGINT NOT NULL,
   fk_artefact BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_proj_note table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_proj_note' AND xtype='U')
CREATE TABLE o_proj_note (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   p_title NVARCHAR(128),
   p_text NVARCHAR(MAX),  -- Changed LONGTEXT to NVARCHAR(MAX)
   fk_artefact BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_proj_appointment table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_proj_appointment' AND xtype='U')
CREATE TABLE o_proj_appointment (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   p_identifier NVARCHAR(64) NOT NULL,
   p_event_id NVARCHAR(64) NOT NULL,
   p_recurrence_id NVARCHAR(500),
   p_start_date DATETIME2,
   p_end_date DATETIME2,
   p_subject NVARCHAR(256),
   p_description NVARCHAR(MAX),  -- Changed LONGTEXT to NVARCHAR(MAX)
   p_location NVARCHAR(1024),
   p_color NVARCHAR(50),
   p_all_day BIT DEFAULT 0 NOT NULL,  -- Changed BOOLEAN to BIT
   p_recurrence_rule NVARCHAR(100),
   p_recurrence_exclusion NVARCHAR(4000),
   fk_artefact BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_proj_milestone table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_proj_milestone' AND xtype='U')
CREATE TABLE o_proj_milestone (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   p_identifier NVARCHAR(64) NOT NULL,
   p_status NVARCHAR(32),
   p_due_date DATETIME2,
   p_subject NVARCHAR(256),
   p_description NVARCHAR(MAX),  -- Changed LONGTEXT to NVARCHAR(MAX)
   p_color NVARCHAR(50),
   fk_artefact BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_proj_decision table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_proj_decision' AND xtype='U')
CREATE TABLE o_proj_decision (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   p_title NVARCHAR(2000),
   p_details NVARCHAR(MAX),  -- Changed LONGTEXT to NVARCHAR(MAX)
   p_decision_date DATETIME2,
   fk_artefact BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_proj_activity table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_proj_activity' AND xtype='U')
CREATE TABLE o_proj_activity (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   p_action NVARCHAR(64) NOT NULL,
   p_action_target NVARCHAR(32) NOT NULL,
   p_before NVARCHAR(MAX),  -- Changed LONGTEXT to NVARCHAR(MAX)
   p_after NVARCHAR(MAX),  -- Changed LONGTEXT to NVARCHAR(MAX)
   p_temp_identifier NVARCHAR(100),
   fk_doer BIGINT NOT NULL,
   fk_project BIGINT NOT NULL,
   fk_artefact BIGINT,
   fk_artefact_reference BIGINT,
   fk_member BIGINT,
   fk_organisation BIGINT,
   PRIMARY KEY (id)
);

-- Check and create o_jup_hub table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_jup_hub' AND xtype='U')
CREATE TABLE o_jup_hub (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   j_name NVARCHAR(255) NOT NULL,
   j_status NVARCHAR(255) NOT NULL,
   j_ram NVARCHAR(255) NOT NULL,
   j_cpu BIGINT NOT NULL,
   j_image_checking_service_url NVARCHAR(255),
   j_info_text NVARCHAR(MAX),  -- Changed MEDIUMTEXT to NVARCHAR(MAX)
   j_lti_key NVARCHAR(255),
   j_access_token NVARCHAR(255),
   j_agreement_setting NVARCHAR(32) DEFAULT 'suppressAgreement' NOT NULL,
   fk_lti_tool_id BIGINT NOT NULL,
   PRIMARY KEY (id)
);

-- Check and create o_jup_deployment table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_jup_deployment' AND xtype='U')
CREATE TABLE o_jup_deployment (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   j_description NVARCHAR(255),
   j_image NVARCHAR(255) NOT NULL,
   j_suppress_data_transmission_agreement BIT,  -- Changed BOOLEAN to BIT
   fk_hub BIGINT NOT NULL,
   fk_lti_tool_deployment_id BIGINT NOT NULL,
   fk_lti_context_id BIGINT,
   PRIMARY KEY (id)
);

-- Check and create o_badge_template table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_badge_template' AND xtype='U')
CREATE TABLE o_badge_template (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   b_identifier NVARCHAR(36) NOT NULL,
   b_image NVARCHAR(256) NOT NULL,
   b_name NVARCHAR(1024) NOT NULL,
   b_description NVARCHAR(MAX),  -- Changed LONGTEXT to NVARCHAR(MAX)
   b_scopes NVARCHAR(128),
   b_placeholders NVARCHAR(1024),
   PRIMARY KEY (id)
);

-- Check and create o_badge_class table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_badge_class' AND xtype='U')
CREATE TABLE o_badge_class (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   b_uuid NVARCHAR(36) NOT NULL,
   b_status NVARCHAR(256) NOT NULL,
   b_version NVARCHAR(32) NOT NULL,
   b_language NVARCHAR(32),
   b_image NVARCHAR(256) NOT NULL,
   b_name NVARCHAR(256) NOT NULL,
   b_description NVARCHAR(1024) NOT NULL,
   b_criteria NVARCHAR(MAX),  -- Changed LONGTEXT to NVARCHAR(MAX)
   b_salt NVARCHAR(128) NOT NULL,
   b_issuer NVARCHAR(1024) NOT NULL,
   b_validity_enabled BIT DEFAULT 0 NOT NULL,  -- Changed BOOLEAN to BIT
   b_validity_timelapse BIGINT DEFAULT 0 NOT NULL,
   b_validity_timelapse_unit NVARCHAR(32),
   fk_entry BIGINT,
   PRIMARY KEY (id)
);

-- Check and create o_badge_assertion table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_badge_assertion' AND xtype='U')
CREATE TABLE o_badge_assertion (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   b_uuid NVARCHAR(36) NOT NULL,
   b_status NVARCHAR(256) NOT NULL,
   b_recipient NVARCHAR(1024) NOT NULL,
   b_verification NVARCHAR(256) NOT NULL,
   b_issued_on DATETIME2 NOT NULL,
   b_baked_image NVARCHAR(256),
   b_evidence NVARCHAR(256),
   b_narrative NVARCHAR(1024),
   b_expires DATETIME2,
   b_revocation_reason NVARCHAR(256),
   fk_badge_class BIGINT NOT NULL,
   fk_recipient BIGINT NOT NULL,
   fk_awarded_by BIGINT,
   PRIMARY KEY (id)
);

-- Check and create o_badge_category table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_badge_category' AND xtype='U')
CREATE TABLE o_badge_category (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   fk_tag BIGINT NOT NULL,
   fk_template BIGINT,
   fk_class BIGINT,
   PRIMARY KEY (id)
);

-- Check and create o_badge_entry_config table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_badge_entry_config' AND xtype='U')
CREATE TABLE o_badge_entry_config (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   b_award_enabled BIT DEFAULT 0 NOT NULL,  -- Changed BOOLEAN to BIT
   b_owner_can_award BIT DEFAULT 0 NOT NULL,  -- Changed BOOLEAN to BIT
   b_coach_can_award BIT DEFAULT 0 NOT NULL,  -- Changed BOOLEAN to BIT
   fk_entry BIGINT NOT NULL,
   UNIQUE(fk_entry),
   PRIMARY KEY (id)
);

-- Check and create o_gui_prefs table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='o_gui_prefs' AND xtype='U')
CREATE TABLE o_gui_prefs (
   id BIGINT NOT NULL IDENTITY(1,1),
   creationdate DATETIME2 NOT NULL,
   lastmodified DATETIME2 NOT NULL,
   fk_identity BIGINT NOT NULL,
   g_pref_attributed_class NVARCHAR(512) NOT NULL,
   g_pref_key NVARCHAR(512) NOT NULL,
   g_pref_value NVARCHAR(MAX) NOT NULL,  -- Changed LONGTEXT to NVARCHAR(MAX)
   PRIMARY KEY (id)
);

-- eleventh round
-- create views
-- user view
IF EXISTS (SELECT * FROM sysobjects WHERE name='o_bs_identity_short_v' AND xtype='V')
    DROP VIEW o_bs_identity_short_v;
GO

CREATE VIEW o_bs_identity_short_v AS (
   SELECT
      ident.id AS id_id,
      ident.name AS id_name,
      ident.external_id AS id_external,
      ident.lastlogin AS id_lastlogin,
      ident.status AS id_status,
      us.user_id AS us_id,
      us.u_firstname AS first_name,
      us.u_lastname AS last_name,
      us.u_nickname AS nick_name,
      us.u_email AS email
   FROM o_bs_identity AS ident
   INNER JOIN o_user AS us ON (ident.id = us.fk_identity)
);
GO

-- business to repository view
IF EXISTS (SELECT * FROM sysobjects WHERE name='o_gp_business_to_repository_v' AND xtype='V')
    DROP VIEW o_gp_business_to_repository_v;
GO

CREATE VIEW o_gp_business_to_repository_v AS (
    SELECT
        grp.group_id AS grp_id,
        repoentry.repositoryentry_id AS re_id,
        repoentry.displayname AS re_displayname
    FROM o_gp_business AS grp
    INNER JOIN o_re_to_group AS relation ON (relation.fk_group_id = grp.fk_group_id)
    INNER JOIN o_repositoryentry AS repoentry ON (repoentry.repositoryentry_id = relation.fk_entry_id)
);
GO

-- group membership view
IF EXISTS (SELECT * FROM sysobjects WHERE name='o_bs_gp_membership_v' AND xtype='V')
    DROP VIEW o_bs_gp_membership_v;
GO

CREATE VIEW o_bs_gp_membership_v AS (
   SELECT
      membership.id AS membership_id,
      membership.fk_identity_id AS fk_identity_id,
      membership.lastmodified AS lastmodified,
      membership.creationdate AS creationdate,
      membership.g_role AS g_role,
      gp.group_id AS group_id
   FROM o_bs_group_member AS membership
   INNER JOIN o_gp_business AS gp ON (gp.fk_group_id=membership.fk_group_id)
);
GO

-- repository membership view
IF EXISTS (SELECT * FROM sysobjects WHERE name='o_re_membership_v' AND xtype='V')
    DROP VIEW o_re_membership_v;
GO

CREATE VIEW o_re_membership_v AS (
   SELECT
      bmember.id AS membership_id,
      bmember.creationdate AS creationdate,
      bmember.lastmodified AS lastmodified,
      bmember.fk_identity_id AS fk_identity_id,
      bmember.g_role AS g_role,
      re.repositoryentry_id AS fk_entry_id
   FROM o_repositoryentry AS re
   INNER JOIN o_re_to_group relgroup ON (relgroup.fk_entry_id=re.repositoryentry_id AND relgroup.r_defgroup=1)
   INNER JOIN o_bs_group_member AS bmember ON (bmember.fk_group_id=relgroup.fk_group_id)
);
GO

-- contact key view
IF EXISTS (SELECT * FROM sysobjects WHERE name='o_gp_contactkey_v' AND xtype='V')
    DROP VIEW o_gp_contactkey_v;
GO

CREATE VIEW o_gp_contactkey_v AS (
   SELECT
      bg_member.id AS membership_id,
      bg_member.fk_identity_id AS member_id,
      bg_member.g_role AS membership_role,
      bg_me.fk_identity_id AS me_id,
      bgroup.group_id AS bg_id
   FROM o_gp_business AS bgroup
   INNER JOIN o_bs_group_member AS bg_member ON (bg_member.fk_group_id = bgroup.fk_group_id)
   INNER JOIN o_bs_group_member AS bg_me ON (bg_me.fk_group_id = bgroup.fk_group_id)
   WHERE
      (bgroup.ownersintern=1 AND bg_member.g_role='coach')
      OR
      (bgroup.participantsintern=1 AND bg_member.g_role='participant')
);
GO

-- contact external view
IF EXISTS (SELECT * FROM sysobjects WHERE name='o_gp_contactext_v' AND xtype='V')
    DROP VIEW o_gp_contactext_v;
GO

CREATE VIEW o_gp_contactext_v AS (
   SELECT
      bg_member.id AS membership_id,
      bg_member.fk_identity_id AS member_id,
      bg_member.g_role AS membership_role,
      id_member.name AS member_name,
      us_member.u_firstname AS member_firstname,
      us_member.u_lastname AS member_lastname,
      bg_me.fk_identity_id AS me_id,
      bgroup.group_id AS bg_id,
      bgroup.groupname AS bg_name
   FROM o_gp_business AS bgroup
   INNER JOIN o_bs_group_member AS bg_member ON (bg_member.fk_group_id = bgroup.fk_group_id)
   INNER JOIN o_bs_identity AS id_member ON (bg_member.fk_identity_id = id_member.id)
   INNER JOIN o_user AS us_member ON (id_member.id = us_member.fk_identity)
   INNER JOIN o_bs_group_member AS bg_me ON (bg_me.fk_group_id = bgroup.fk_group_id)
   WHERE
      (bgroup.ownersintern=1 AND bg_member.g_role='coach')
      OR
      (bgroup.participantsintern=1 AND bg_member.g_role='participant')
);
GO

-- pool to item short view
IF EXISTS (SELECT * FROM sysobjects WHERE name='o_qp_pool_2_item_short_v' AND xtype='V')
    DROP VIEW o_qp_pool_2_item_short_v;
GO

CREATE VIEW o_qp_pool_2_item_short_v AS (
   SELECT
      pool2item.id AS item_to_pool_id,
      pool2item.creationdate AS item_to_pool_creationdate,
      item.id AS item_id,
      pool2item.q_editable AS item_editable,
      pool2item.fk_pool_id AS item_pool,
      pool.q_name AS item_pool_name
   FROM o_qp_item AS item
   INNER JOIN o_qp_pool_2_item AS pool2item ON (pool2item.fk_item_id = item.id)
   INNER JOIN o_qp_pool AS pool ON (pool2item.fk_pool_id = pool.id)
);
GO

-- share to item short view
IF EXISTS (SELECT * FROM sysobjects WHERE name='o_qp_share_2_item_short_v' AND xtype='V')
    DROP VIEW o_qp_share_2_item_short_v;
GO

CREATE VIEW o_qp_share_2_item_short_v AS (
   SELECT
      shareditem.id AS item_to_share_id,
      shareditem.creationdate AS item_to_share_creationdate,
      item.id AS item_id,
      shareditem.q_editable AS item_editable,
      shareditem.fk_resource_id AS resource_id,
      bgroup.groupname AS resource_name
   FROM o_qp_item AS item
   INNER JOIN o_qp_share_item AS shareditem ON (shareditem.fk_item_id = item.id)
   INNER JOIN o_gp_business AS bgroup ON (shareditem.fk_resource_id = bgroup.fk_resource)
);
GO


-- Create index on oc_lock table
CREATE INDEX ocl_asset_idx ON oc_lock (asset);
GO

-- Add foreign key constraint to oc_lock table
ALTER TABLE oc_lock 
ADD CONSTRAINT FK9E30F4B66115906D 
FOREIGN KEY (identity_fk) REFERENCES o_bs_identity (id);
GO

-- Add index on identity_fk column
CREATE INDEX FK9E30F4B66115906D ON oc_lock (identity_fk);
GO

-- Rating Table
-- Adding foreign key constraint
ALTER TABLE o_userrating 
ADD CONSTRAINT FKF26C8375236F20X 
FOREIGN KEY (creator_id) REFERENCES o_bs_identity (id);

CREATE INDEX rtn_id_idx ON o_userrating (resid);
CREATE INDEX rtn_name_idx ON o_userrating (resname);
CREATE INDEX rtn_rating_idx ON o_userrating (rating);
CREATE INDEX rtn_rating_res_idx ON o_userrating (resid, resname, creator_id, rating);
-- Add a computed column for the first 255 characters of ressubpath
ALTER TABLE o_userrating
ADD ressubpath_prefix AS LEFT(ressubpath, 255);
-- Create an index on the computed column
CREATE INDEX rtn_subpath_idx ON o_userrating (ressubpath_prefix);


-- Comment Table
ALTER TABLE o_usercomment 
ADD CONSTRAINT FK92B6864A18251F0 
FOREIGN KEY (parent_key) REFERENCES o_usercomment (comment_id);

ALTER TABLE o_usercomment 
ADD CONSTRAINT FKF26C8375236F20A 
FOREIGN KEY (creator_id) REFERENCES o_bs_identity (id);

CREATE INDEX cmt_id_idx ON o_usercomment (resid);
CREATE INDEX cmt_name_idx ON o_usercomment (resname);

ALTER TABLE o_usercomment
ADD ressubpath_prefix AS LEFT(ressubpath, 255);

CREATE INDEX cmt_subpath_idx ON o_usercomment (ressubpath_prefix);

-- Checkpoint Table
ALTER TABLE o_checkpoint_results 
ADD CONSTRAINT FK9E30F4B661159ZZY 
FOREIGN KEY (checkpoint_fk) REFERENCES o_checkpoint (checkpoint_id);

ALTER TABLE o_checkpoint_results 
ADD CONSTRAINT FK9E30F4B661159ZZX 
FOREIGN KEY (identity_fk) REFERENCES o_bs_identity (id);

ALTER TABLE o_checkpoint 
ADD CONSTRAINT FK9E30F4B661159ZZZ 
FOREIGN KEY (checklist_fk) REFERENCES o_checklist (checklist_id);

-- Plock Table
CREATE INDEX asset_idx ON o_plock (asset);



-- Property Table
ALTER TABLE o_property 
ADD CONSTRAINT FKB60B1BA5190E5 
FOREIGN KEY (grp) REFERENCES o_gp_business (group_id);

ALTER TABLE o_property 
ADD CONSTRAINT FKB60B1BA5F7E870BE 
FOREIGN KEY (idprofile) REFERENCES o_bs_identity (id);

CREATE INDEX idx_prop_indexresid_idx ON o_property (resourcetypeid);
CREATE INDEX idx_prop_category_idx ON o_property (category);
CREATE INDEX idx_prop_name_idx ON o_property (name);
CREATE INDEX idx_prop_restype_idx ON o_property (resourcetypename);


-- Group Table
ALTER TABLE o_bs_group_member 
ADD CONSTRAINT member_identity_ctx 
FOREIGN KEY (fk_identity_id) REFERENCES o_bs_identity (id);

ALTER TABLE o_bs_group_member 
ADD CONSTRAINT member_group_ctx 
FOREIGN KEY (fk_group_id) REFERENCES o_bs_group (id);

CREATE INDEX group_role_member_idx ON o_bs_group_member (fk_group_id, g_role, fk_identity_id);

ALTER TABLE o_re_to_group 
ADD CONSTRAINT re_to_group_group_ctx 
FOREIGN KEY (fk_group_id) REFERENCES o_bs_group (id);

ALTER TABLE o_re_to_group 
ADD CONSTRAINT re_to_group_re_ctx 
FOREIGN KEY (fk_entry_id) REFERENCES o_repositoryentry (repositoryentry_id);

ALTER TABLE o_gp_business 
ADD CONSTRAINT gp_to_group_business_ctx 
FOREIGN KEY (fk_group_id) REFERENCES o_bs_group (id);


-- Business Group Table
ALTER TABLE o_gp_business 
ADD CONSTRAINT idx_bgp_rsrc 
FOREIGN KEY (fk_resource) REFERENCES o_olatresource (resource_id);

CREATE INDEX gp_name_idx ON o_gp_business (groupname);
CREATE INDEX idx_grp_lifecycle_soft_idx ON o_gp_business (external_id);
CREATE INDEX gp_tech_type_idx ON o_gp_business (technical_type);

ALTER TABLE o_bs_namedgroup 
ADD CONSTRAINT FKBAFCBBC4B85B522C 
FOREIGN KEY (secgroup_id) REFERENCES o_bs_secgroup (id);

CREATE INDEX groupname_idx ON o_bs_namedgroup (groupname);

ALTER TABLE o_gp_business 
ADD CONSTRAINT gb_bus_inactivateby_idx 
FOREIGN KEY (fk_inactivatedby_id) REFERENCES o_bs_identity (id);

ALTER TABLE o_gp_business 
ADD CONSTRAINT gb_bus_softdeletedby_idx 
FOREIGN KEY (fk_softdeletedby_id) REFERENCES o_bs_identity (id);


-- Area Table
ALTER TABLE o_gp_bgarea 
ADD CONSTRAINT idx_area_to_resource 
FOREIGN KEY (fk_resource) REFERENCES o_olatresource (resource_id);

CREATE INDEX name_idx ON o_gp_bgarea (name);

ALTER TABLE o_gp_bgtoarea_rel 
ADD CONSTRAINT FK9B663F2D1E2E7685 
FOREIGN KEY (group_fk) REFERENCES o_gp_business (group_id);

ALTER TABLE o_gp_bgtoarea_rel 
ADD CONSTRAINT FK9B663F2DD381B9B7 
FOREIGN KEY (area_fk) REFERENCES o_gp_bgarea (area_id);


-- BS Table
-- Adding constraints and indexes for o_bs_authentication table
ALTER TABLE o_bs_authentication
ADD CONSTRAINT FKC6A5445652595FE6 FOREIGN KEY (identity_fk) REFERENCES o_bs_identity (id);

ALTER TABLE o_bs_authentication
ADD CONSTRAINT unique_pro_iss_authusername UNIQUE (provider, issuer, authusername);

ALTER TABLE o_bs_authentication
ADD CONSTRAINT unique_pro_iss_externalid UNIQUE (provider, issuer, externalid);

CREATE INDEX provider_idx ON o_bs_authentication (provider);
CREATE INDEX credential_idx ON o_bs_authentication (credential);
CREATE INDEX authusername_idx ON o_bs_authentication (authusername);

-- Adding foreign key constraint for o_bs_authentication_history table
ALTER TABLE o_bs_authentication_history
ADD CONSTRAINT auth_hist_to_ident_idx FOREIGN KEY (fk_identity) REFERENCES o_bs_identity (id);

-- Adding foreign key constraint for o_bs_recovery_key table
ALTER TABLE o_bs_recovery_key
ADD CONSTRAINT rec_key_to_ident_idx FOREIGN KEY (fk_identity) REFERENCES o_bs_identity(id);

-- Adding foreign key constraint for o_bs_webauthn_stats table
ALTER TABLE o_bs_webauthn_stats
ADD CONSTRAINT weba_counter_toident_idx FOREIGN KEY (fk_identity) REFERENCES o_bs_identity(id);

-- Adding indexes on o_bs_identity table
CREATE INDEX name_idx ON o_bs_identity (name);
CREATE INDEX identstatus_idx ON o_bs_identity (status);
CREATE INDEX idx_ident_creationdate_idx ON o_bs_identity (creationdate);
CREATE INDEX idx_id_lastlogin_idx ON o_bs_identity (lastlogin);

-- Adding constraints for o_bs_membership table
ALTER TABLE o_bs_membership
ADD CONSTRAINT FK7B6288B45259603C FOREIGN KEY (identity_id) REFERENCES o_bs_identity (id);

ALTER TABLE o_bs_membership
ADD CONSTRAINT FK7B6288B4B85B522C FOREIGN KEY (secgroup_id) REFERENCES o_bs_secgroup (id);

-- Adding constraints for o_bs_invitation table
ALTER TABLE o_bs_invitation
ADD CONSTRAINT inv_to_group_group_ctx FOREIGN KEY (fk_group_id) REFERENCES o_bs_group (id);

ALTER TABLE o_bs_invitation
ADD CONSTRAINT invit_to_id_idx FOREIGN KEY (fk_identity_id) REFERENCES o_bs_identity (id);


-- Creating index for o_bs_relation_right table
CREATE INDEX idx_right_idx ON o_bs_relation_right (g_right);

-- Adding constraints for o_bs_relation_role_to_right table
ALTER TABLE o_bs_relation_role_to_right
ADD CONSTRAINT role_to_right_role_idx FOREIGN KEY (fk_role_id) REFERENCES o_bs_relation_role (id);

ALTER TABLE o_bs_relation_role_to_right
ADD CONSTRAINT role_to_right_right_idx FOREIGN KEY (fk_right_id) REFERENCES o_bs_relation_right (id);


-- Adding constraints for o_bs_identity_to_identity table
ALTER TABLE o_bs_identity_to_identity
ADD CONSTRAINT id_to_id_source_idx FOREIGN KEY (fk_source_id) REFERENCES o_bs_identity (id);

ALTER TABLE o_bs_identity_to_identity
ADD CONSTRAINT id_to_id_target_idx FOREIGN KEY (fk_target_id) REFERENCES o_bs_identity (id);

ALTER TABLE o_bs_identity_to_identity
ADD CONSTRAINT id_to_role_idx FOREIGN KEY (fk_role_id) REFERENCES o_bs_relation_role (id);



-- user
-- Creating indexes for o_user table
CREATE INDEX usr_notification_interval_idx ON o_user (notification_interval);
CREATE INDEX idx_user_firstname_idx ON o_user (u_firstname);
CREATE INDEX idx_user_lastname_idx ON o_user (u_lastname);
CREATE INDEX idx_user_nickname_idx ON o_user (u_nickname);
CREATE INDEX idx_user_email_idx ON o_user (u_email);
CREATE INDEX idx_user_instname_idx ON o_user (u_institutionalname);
CREATE INDEX idx_user_instid_idx ON o_user (u_institutionaluseridentifier);
CREATE INDEX idx_user_instemail_idx ON o_user (u_institutionalemail);
CREATE INDEX idx_user_creationdate_idx ON o_user (creationdate);


-- Adding unique constraint for o_user table
ALTER TABLE o_user
ADD CONSTRAINT iuni_user_nickname_idx UNIQUE (u_nickname);

-- Adding foreign key constraint for o_user table
ALTER TABLE o_user
ADD CONSTRAINT user_to_ident_idx FOREIGN KEY (fk_identity) REFERENCES o_bs_identity (id);

-- Adding unique constraint for o_user table
ALTER TABLE o_user
ADD CONSTRAINT idx_un_user_to_ident_idx UNIQUE (fk_identity);

-- Adding foreign key constraint for o_user_data_export table
ALTER TABLE o_user_data_export
ADD CONSTRAINT usr_dataex_to_ident_idx FOREIGN KEY (fk_identity) REFERENCES o_bs_identity (id);

ALTER TABLE o_user_data_export
ADD CONSTRAINT usr_dataex_to_requ_idx FOREIGN KEY (fk_request_by) REFERENCES o_bs_identity (id);

-- Adding foreign key constraint for o_user_absence_leave table
ALTER TABLE o_user_absence_leave
ADD CONSTRAINT abs_leave_to_ident_idx FOREIGN KEY (fk_identity) REFERENCES o_bs_identity (id);


-- csp
CREATE INDEX idx_csp_log_to_ident_idx ON o_csp_log (fk_identity);

-- temporary key
CREATE INDEX idx_tempkey_identity_idx ON o_temporarykey (fk_identity_id);

-- pub sub
CREATE INDEX name_idx ON o_noti_pub (resname, resid, subident);

ALTER TABLE o_noti_sub
ADD CONSTRAINT FK4FB8F04749E53702 FOREIGN KEY (fk_publisher) REFERENCES o_noti_pub (publisher_id);

ALTER TABLE o_noti_sub
ADD CONSTRAINT FK4FB8F0476B1F22F8 FOREIGN KEY (fk_identity) REFERENCES o_bs_identity (id);

-- catalog entry
ALTER TABLE o_catentry
ADD CONSTRAINT FKF4433C2C7B66B0D0 FOREIGN KEY (parent_id) REFERENCES o_catentry (id);

ALTER TABLE o_catentry
ADD CONSTRAINT FKF4433C2CA1FAC766 FOREIGN KEY (fk_ownergroup) REFERENCES o_bs_secgroup (id);

ALTER TABLE o_catentry
ADD CONSTRAINT FKF4433C2CDDD69946 FOREIGN KEY (fk_repoentry) REFERENCES o_repositoryentry (repositoryentry_id);

-- references
ALTER TABLE o_references
ADD CONSTRAINT FKE971B4589AC44FBF FOREIGN KEY (source_id) REFERENCES o_olatresource (resource_id);

ALTER TABLE o_references
ADD CONSTRAINT FKE971B458CF634A89 FOREIGN KEY (target_id) REFERENCES o_olatresource (resource_id);

-- resources
CREATE INDEX name_idx ON o_olatresource (resname);
CREATE INDEX id_idx ON o_olatresource (resid);

-- repository
ALTER TABLE o_repositoryentry
ADD CONSTRAINT FK2F9C439888C31018 FOREIGN KEY (fk_olatresource) REFERENCES o_olatresource (resource_id);

CREATE INDEX re_status_idx ON o_repositoryentry (status);
CREATE INDEX initialAuthor_idx ON o_repositoryentry (initialauthor);
CREATE INDEX resource_idx ON o_repositoryentry (resourcename);
CREATE INDEX displayname_idx ON o_repositoryentry (displayname);
CREATE INDEX softkey_idx ON o_repositoryentry (softkey);
CREATE INDEX idx_re_lifecycle_extid_idx ON o_repositoryentry (external_id);
CREATE INDEX idx_re_lifecycle_extref_idx ON o_repositoryentry (external_ref);

ALTER TABLE o_repositoryentry
ADD CONSTRAINT idx_re_lifecycle_fk FOREIGN KEY (fk_lifecycle) REFERENCES o_repositoryentry_cycle (id);

CREATE INDEX idx_re_lifecycle_soft_idx ON o_repositoryentry_cycle (r_softkey);

ALTER TABLE o_repositoryentry
ADD CONSTRAINT repoentry_stats_ctx FOREIGN KEY (fk_stats) REFERENCES o_repositoryentry_stats (id);

ALTER TABLE o_repositoryentry
ADD CONSTRAINT re_deleted_to_identity_idx FOREIGN KEY (fk_deleted_by) REFERENCES o_bs_identity (id);

ALTER TABLE o_re_to_tax_level
ADD CONSTRAINT re_to_lev_re_idx FOREIGN KEY (fk_entry) REFERENCES o_repositoryentry (repositoryentry_id);

ALTER TABLE o_re_to_tax_level
ADD CONSTRAINT re_to_lev_tax_lev_idx FOREIGN KEY (fk_taxonomy_level) REFERENCES o_tax_taxonomy_level (id);

ALTER TABLE o_repositoryentry
ADD CONSTRAINT idx_re_edu_type_fk FOREIGN KEY (fk_educational_type) REFERENCES o_re_educational_type (id);

CREATE UNIQUE INDEX idc_re_edu_type_ident ON o_re_educational_type (r_identifier);

-- access control
CREATE INDEX ac_offer_to_resource_idx ON o_ac_offer (fk_resource_id);
CREATE INDEX idx_offer_guest_idx ON o_ac_offer (guest_access);
CREATE INDEX idx_offer_open_idx ON o_ac_offer (open_access);

ALTER TABLE o_ac_offer_to_organisation
ADD CONSTRAINT rel_oto_offer_idx FOREIGN KEY (fk_offer) REFERENCES o_ac_offer (offer_id);

ALTER TABLE o_ac_offer_to_organisation
ADD CONSTRAINT rel_oto_org_idx FOREIGN KEY (fk_organisation) REFERENCES o_org_organisation (id);

ALTER TABLE o_ac_offer_access
ADD CONSTRAINT off_to_meth_meth_ctx FOREIGN KEY (fk_method_id) REFERENCES o_ac_method (method_id);

ALTER TABLE o_ac_offer_access
ADD CONSTRAINT off_to_meth_off_ctx FOREIGN KEY (fk_offer_id) REFERENCES o_ac_offer (offer_id);

CREATE INDEX ac_order_to_delivery_idx ON o_ac_order (fk_delivery_id);

ALTER TABLE o_ac_order_part
ADD CONSTRAINT ord_part_ord_ctx FOREIGN KEY (fk_order_id) REFERENCES o_ac_order (order_id);

ALTER TABLE o_ac_order_line
ADD CONSTRAINT ord_item_ord_part_ctx FOREIGN KEY (fk_order_part_id) REFERENCES o_ac_order_part (order_part_id);

ALTER TABLE o_ac_order_line
ADD CONSTRAINT ord_item_offer_ctx FOREIGN KEY (fk_offer_id) REFERENCES o_ac_offer (offer_id);

ALTER TABLE o_ac_transaction
ADD CONSTRAINT trans_ord_ctx FOREIGN KEY (fk_order_id) REFERENCES o_ac_order (order_id);

ALTER TABLE o_ac_transaction
ADD CONSTRAINT trans_ord_part_ctx FOREIGN KEY (fk_order_part_id) REFERENCES o_ac_order_part (order_part_id);

ALTER TABLE o_ac_transaction
ADD CONSTRAINT trans_method_ctx FOREIGN KEY (fk_method_id) REFERENCES o_ac_method (method_id);

CREATE INDEX paypal_pay_key_idx ON o_ac_paypal_transaction (pay_key);
CREATE INDEX paypal_pay_trx_id_idx ON o_ac_paypal_transaction (ipn_transaction_id);
CREATE INDEX paypal_pay_s_trx_id_idx ON o_ac_paypal_transaction (ipn_sender_transaction_id);

CREATE INDEX idx_ac_aao_id_idx ON o_ac_auto_advance_order (id);
CREATE INDEX idx_ac_aao_identifier_idx ON o_ac_auto_advance_order (a_identifier_key, a_identifier_value);
CREATE INDEX idx_ac_aao_ident_idx ON o_ac_auto_advance_order (fk_identity);

ALTER TABLE o_ac_auto_advance_order
ADD CONSTRAINT aao_ident_idx FOREIGN KEY (fk_identity) REFERENCES o_bs_identity (id);

-- reservations
ALTER TABLE o_ac_reservation
ADD CONSTRAINT idx_rsrv_to_rsrc_rsrc FOREIGN KEY (fk_resource) REFERENCES o_olatresource (resource_id);

ALTER TABLE o_ac_reservation
ADD CONSTRAINT idx_rsrv_to_rsrc_identity FOREIGN KEY (fk_identity) REFERENCES o_bs_identity (id);

-- catalog
ALTER TABLE o_ca_launcher_to_organisation
ADD CONSTRAINT rel_lto_launcher_idx FOREIGN KEY (fk_launcher) REFERENCES o_ca_launcher (id);

ALTER TABLE o_ca_launcher_to_organisation
ADD CONSTRAINT rel_lto_org_idx FOREIGN KEY (fk_organisation) REFERENCES o_org_organisation (id);

-- note
ALTER TABLE o_note
ADD CONSTRAINT FKC2D855C263219E27 FOREIGN KEY (owner_id) REFERENCES o_bs_identity (id);

CREATE INDEX resid_idx ON o_note (resourcetypeid);
CREATE INDEX owner_idx ON o_note (owner_id);
CREATE INDEX restype_idx ON o_note (resourcetypename);

-- ex_task
ALTER TABLE o_ex_task
ADD CONSTRAINT idx_ex_task_ident_id FOREIGN KEY (fk_identity_id) REFERENCES o_bs_identity (id);

ALTER TABLE o_ex_task
ADD CONSTRAINT idx_ex_task_rsrc_id FOREIGN KEY (fk_resource_id) REFERENCES o_olatresource (resource_id);

ALTER TABLE o_ex_task_modifier
ADD CONSTRAINT idx_ex_task_mod_ident_id FOREIGN KEY (fk_identity_id) REFERENCES o_bs_identity (id);

ALTER TABLE o_ex_task_modifier
ADD CONSTRAINT idx_ex_task_mod_task_id FOREIGN KEY (fk_task_id) REFERENCES o_ex_task (id);

-- checklist
ALTER TABLE o_cl_check
ADD CONSTRAINT check_identity_ctx FOREIGN KEY (fk_identity_id) REFERENCES o_bs_identity (id);

ALTER TABLE o_cl_check
ADD CONSTRAINT check_box_ctx FOREIGN KEY (fk_checkbox_id) REFERENCES o_cl_checkbox (id);

ALTER TABLE o_cl_check
ADD CONSTRAINT check_identity_unique_ctx UNIQUE (fk_identity_id, fk_checkbox_id);

CREATE INDEX idx_checkbox_uuid_idx ON o_cl_checkbox (c_checkboxid);

-- group tasks
ALTER TABLE o_gta_task
ADD CONSTRAINT gtask_to_tasklist_idx FOREIGN KEY (fk_tasklist) REFERENCES o_gta_task_list (id);

ALTER TABLE o_gta_task
ADD CONSTRAINT gtask_to_identity_idx FOREIGN KEY (fk_identity) REFERENCES o_bs_identity (id);

ALTER TABLE o_gta_task
ADD CONSTRAINT gtask_to_bgroup_idx FOREIGN KEY (fk_businessgroup) REFERENCES o_gp_business (group_id);

ALTER TABLE o_gta_task
ADD CONSTRAINT gtaskreset_to_allower_idx FOREIGN KEY (fk_allow_reset_identity) REFERENCES o_bs_identity (id);

ALTER TABLE o_gta_task_list
ADD CONSTRAINT gta_list_to_repo_entry_idx FOREIGN KEY (fk_entry) REFERENCES o_repositoryentry (repositoryentry_id);

ALTER TABLE o_gta_task_revision
ADD CONSTRAINT task_rev_to_task_idx FOREIGN KEY (fk_task) REFERENCES o_gta_task (id);

ALTER TABLE o_gta_task_revision
ADD CONSTRAINT task_rev_to_ident_idx FOREIGN KEY (fk_comment_author) REFERENCES o_bs_identity (id);

ALTER TABLE o_gta_task_revision_date
ADD CONSTRAINT gtaskrev_to_task_idx FOREIGN KEY (fk_task) REFERENCES o_gta_task (id);

ALTER TABLE o_gta_mark
ADD CONSTRAINT gtamark_tasklist_idx FOREIGN KEY (fk_tasklist_id) REFERENCES o_gta_task_list (id);

-- reminders
ALTER TABLE o_rem_reminder
ADD CONSTRAINT rem_reminder_to_repo_entry_idx FOREIGN KEY (fk_entry) REFERENCES o_repositoryentry (repositoryentry_id);

ALTER TABLE o_rem_reminder
ADD CONSTRAINT rem_reminder_to_creator_idx FOREIGN KEY (fk_creator) REFERENCES o_bs_identity (id);

ALTER TABLE o_rem_sent_reminder
ADD CONSTRAINT rem_sent_rem_to_ident_idx FOREIGN KEY (fk_identity) REFERENCES o_bs_identity (id);

ALTER TABLE o_rem_sent_reminder
ADD CONSTRAINT rem_sent_rem_to_reminder_idx FOREIGN KEY (fk_reminder) REFERENCES o_rem_reminder (id);

-- lifecycle
CREATE INDEX lc_pref_idx ON o_lifecycle (persistentref);
CREATE INDEX lc_type_idx ON o_lifecycle (persistenttypename);
CREATE INDEX lc_action_idx ON o_lifecycle (action);

-- mark
ALTER TABLE o_mark
ADD CONSTRAINT FKF26C8375236F21X FOREIGN KEY (creator_id) REFERENCES o_bs_identity (id);

CREATE INDEX mark_all_idx ON o_mark (resname, resid, creator_id);
CREATE INDEX mark_id_idx ON o_mark (resid);
CREATE INDEX mark_name_idx ON o_mark (resname);

-- Add computed columns with a reduced length
ALTER TABLE o_mark
ADD ressubpath_short AS LEFT(ressubpath, 255) PERSISTED;

ALTER TABLE o_mark
ADD businesspath_short AS LEFT(businesspath, 255) PERSISTED;

-- Create the indexes on the computed columns
CREATE INDEX mark_subpath_idx ON o_mark (ressubpath_short);
CREATE INDEX mark_businesspath_idx ON o_mark (businesspath_short);

-- forum
CREATE INDEX idx_forum_ref_idx ON o_forum (f_refresid, f_refresname);

ALTER TABLE o_message
ADD CONSTRAINT FKF26C8375236F20E FOREIGN KEY (creator_id) REFERENCES o_bs_identity (id);

ALTER TABLE o_message
ADD CONSTRAINT FKF26C837A3FBEB83 FOREIGN KEY (modifier_id) REFERENCES o_bs_identity (id);

ALTER TABLE o_message
ADD CONSTRAINT FKF26C8377B66B0D0 FOREIGN KEY (parent_id) REFERENCES o_message (message_id);

ALTER TABLE o_message
ADD CONSTRAINT FKF26C8378EAC1DBB FOREIGN KEY (topthread_id) REFERENCES o_message (message_id);

ALTER TABLE o_message
ADD CONSTRAINT FKF26C8371CB7C4A3 FOREIGN KEY (forum_fk) REFERENCES o_forum (forum_id);

CREATE INDEX forum_msg_pseudonym_idx ON o_message (pseudonym);

CREATE INDEX readmessage_forum_idx ON o_readmessage (forum_id);
CREATE INDEX readmessage_identity_idx ON o_readmessage (identity_id);

CREATE INDEX forum_pseudonym_idx ON o_forum_pseudonym (p_pseudonym);

-- project broker
CREATE INDEX projectbroker_project_broker_idx ON o_projectbroker_project (projectbroker_fk);
CREATE INDEX projectbroker_project_id_idx ON o_projectbroker_project (project_id);
CREATE INDEX o_projectbroker_customfields_idx ON o_projectbroker_customfields (fk_project_id);



-- info messages
ALTER TABLE o_info_message ADD CONSTRAINT FKF85553465A4FA5DC FOREIGN KEY (fk_author_id) REFERENCES o_bs_identity (id);
ALTER TABLE o_info_message ADD CONSTRAINT FKF85553465A4FA5EF FOREIGN KEY (fk_modifier_id) REFERENCES o_bs_identity (id);

CREATE INDEX imsg_resid_idx ON o_info_message (resid);

ALTER TABLE o_info_message_to_group ADD CONSTRAINT o_info_message_to_group_msg_idx FOREIGN KEY (fk_info_message_id) REFERENCES o_info_message (info_id);
ALTER TABLE o_info_message_to_group ADD CONSTRAINT o_info_message_to_group_group_idx FOREIGN KEY (fk_group_id) REFERENCES o_gp_business (group_id);

ALTER TABLE o_info_message_to_cur_el ADD CONSTRAINT o_info_message_to_cur_el_msg_idx FOREIGN KEY (fk_info_message_id) REFERENCES o_info_message (info_id);
ALTER TABLE o_info_message_to_cur_el ADD CONSTRAINT o_info_message_to_cur_el_curel_idx FOREIGN KEY (fk_cur_element_id) REFERENCES o_cur_curriculum_element (id);

-- db course
ALTER TABLE o_co_db_entry ADD CONSTRAINT FK_DB_ENTRY_TO_IDENT FOREIGN KEY (idprofile) REFERENCES o_bs_identity (id);

CREATE INDEX o_co_db_course_idx ON o_co_db_entry (courseid);
CREATE INDEX o_co_db_cat_idx ON o_co_db_entry (category);
CREATE INDEX o_co_db_name_idx ON o_co_db_entry (name);

-- open meeting
ALTER TABLE o_om_room_reference ADD CONSTRAINT idx_omroom_to_bgroup FOREIGN KEY (businessgroup) REFERENCES o_gp_business (group_id);
CREATE INDEX idx_omroom_residname ON o_om_room_reference (resourcetypename, resourcetypeid);

-- Adobe Connect
ALTER TABLE o_aconnect_meeting ADD CONSTRAINT aconnect_meet_entry_idx FOREIGN KEY (fk_entry_id) REFERENCES o_repositoryentry (repositoryentry_id);
ALTER TABLE o_aconnect_meeting ADD CONSTRAINT aconnect_meet_grp_idx FOREIGN KEY (fk_group_id) REFERENCES o_gp_business (group_id);

ALTER TABLE o_aconnect_user ADD CONSTRAINT aconn_ident_idx FOREIGN KEY (fk_identity_id) REFERENCES o_bs_identity (id);

-- Bigbluebutton
ALTER TABLE o_bbb_meeting ADD CONSTRAINT bbb_meet_entry_idx FOREIGN KEY (fk_entry_id) REFERENCES o_repositoryentry (repositoryentry_id);
ALTER TABLE o_bbb_meeting ADD CONSTRAINT bbb_meet_grp_idx FOREIGN KEY (fk_group_id) REFERENCES o_gp_business (group_id);
ALTER TABLE o_bbb_meeting ADD CONSTRAINT bbb_meet_template_idx FOREIGN KEY (fk_template_id) REFERENCES o_bbb_template (id);
ALTER TABLE o_bbb_meeting ADD CONSTRAINT bbb_meet_creator_idx FOREIGN KEY (fk_creator_id) REFERENCES o_bs_identity (id);
ALTER TABLE o_bbb_meeting ADD CONSTRAINT bbb_meet_serv_idx FOREIGN KEY (fk_server_id) REFERENCES o_bbb_server (id);
ALTER TABLE o_bbb_meeting ADD CONSTRAINT bbb_dir_idx UNIQUE (b_directory);

ALTER TABLE o_bbb_attendee ADD CONSTRAINT bbb_attend_ident_idx FOREIGN KEY (fk_identity_id) REFERENCES o_bs_identity (id);
ALTER TABLE o_bbb_attendee ADD CONSTRAINT bbb_attend_meet_idx FOREIGN KEY (fk_meeting_id) REFERENCES o_bbb_meeting (id);

ALTER TABLE o_bbb_recording ADD CONSTRAINT bbb_record_meet_idx FOREIGN KEY (fk_meeting_id) REFERENCES o_bbb_meeting (id);

-- Teams
ALTER TABLE o_teams_meeting ADD CONSTRAINT teams_meet_entry_idx FOREIGN KEY (fk_entry_id) REFERENCES o_repositoryentry (repositoryentry_id);
ALTER TABLE o_teams_meeting ADD CONSTRAINT teams_meet_grp_idx FOREIGN KEY (fk_group_id) REFERENCES o_gp_business (group_id);
ALTER TABLE o_teams_meeting ADD CONSTRAINT teams_meet_creator_idx FOREIGN KEY (fk_creator_id) REFERENCES o_bs_identity (id);

ALTER TABLE o_teams_user ADD CONSTRAINT teams_user_ident_idx FOREIGN KEY (fk_identity_id) REFERENCES o_bs_identity (id);

ALTER TABLE o_teams_attendee ADD CONSTRAINT teams_att_ident_idx FOREIGN KEY (fk_identity_id) REFERENCES o_bs_identity (id);
ALTER TABLE o_teams_attendee ADD CONSTRAINT teams_att_user_idx FOREIGN KEY (fk_teams_user_id) REFERENCES o_teams_user (id);
ALTER TABLE o_teams_attendee ADD CONSTRAINT teams_att_meet_idx FOREIGN KEY (fk_meeting_id) REFERENCES o_teams_meeting (id);

-- tag
CREATE UNIQUE INDEX idx_tag_name_idx ON o_tag_tag (t_display_name);

-- ToDo
ALTER TABLE o_todo_task ADD CONSTRAINT todo_task_coll_idx FOREIGN KEY (fk_collection) REFERENCES o_todo_task (id);
CREATE INDEX idx_todo_origin_id_idx ON o_todo_task (t_origin_id);
CREATE INDEX idx_todo_tag_todo_idx ON o_todo_task_tag (fk_todo_task);
CREATE INDEX idx_todo_tag_tag_idx ON o_todo_task_tag (fk_tag);

-- mail
ALTER TABLE o_mail ADD CONSTRAINT FKF86663165A4FA5DC FOREIGN KEY (fk_from_id) REFERENCES o_mail_recipient (recipient_id);
CREATE INDEX idx_mail_meta_id_idx ON o_mail (meta_mail_id);

ALTER TABLE o_mail_recipient ADD CONSTRAINT FKF86663165A4FA5DG FOREIGN KEY (fk_recipient_id) REFERENCES o_bs_identity (id);

ALTER TABLE o_mail_to_recipient ADD CONSTRAINT FKF86663165A4FA5DE FOREIGN KEY (fk_mail_id) REFERENCES o_mail (mail_id);
ALTER TABLE o_mail_to_recipient ADD CONSTRAINT FKF86663165A4FA5DD FOREIGN KEY (fk_recipient_id) REFERENCES o_mail_recipient (recipient_id);

ALTER TABLE o_mail_attachment ADD CONSTRAINT FKF86663165A4FA5DF FOREIGN KEY (fk_att_mail_id) REFERENCES o_mail (mail_id);
CREATE INDEX idx_mail_att_checksum_idx ON o_mail_attachment (datas_checksum);

-- Creating a computed column for datas_path with a maximum length of 100 characters
ALTER TABLE o_mail_attachment ADD datas_path_computed AS LEFT(datas_path, 100) PERSISTED;
CREATE INDEX idx_mail_path_idx ON o_mail_attachment (datas_path_computed);

CREATE INDEX idx_mail_att_siblings_idx ON o_mail_attachment (datas_checksum, mimetype, datas_size, datas_name);

-- instant messaging
ALTER TABLE o_im_message ADD CONSTRAINT idx_im_msg_to_fromid FOREIGN KEY (fk_from_identity_id) REFERENCES o_bs_identity (id);
CREATE INDEX idx_im_msg_res_idx ON o_im_message (msg_resid, msg_resname);
CREATE INDEX idx_im_msg_channel_idx ON o_im_message (msg_resid, msg_resname, msg_ressubpath, msg_channel);

ALTER TABLE o_im_message ADD CONSTRAINT im_msg_bbb_idx FOREIGN KEY (fk_meeting_id) REFERENCES o_bbb_meeting (id);
ALTER TABLE o_im_message ADD CONSTRAINT im_msg_teams_idx FOREIGN KEY (fk_teams_id) REFERENCES o_teams_meeting (id);

ALTER TABLE o_im_notification ADD CONSTRAINT idx_im_not_to_toid FOREIGN KEY (fk_to_identity_id) REFERENCES o_bs_identity (id);
ALTER TABLE o_im_notification ADD CONSTRAINT idx_im_not_to_fromid FOREIGN KEY (fk_from_identity_id) REFERENCES o_bs_identity (id);
CREATE INDEX idx_im_chat_res_idx ON o_im_notification (chat_resid, chat_resname);
CREATE INDEX idx_im_chat_typed_idx ON o_im_notification (fk_to_identity_id, chat_type);

ALTER TABLE o_im_roster_entry ADD CONSTRAINT idx_im_rost_to_id FOREIGN KEY (fk_identity_id) REFERENCES o_bs_identity (id);
CREATE INDEX idx_im_rost_res_idx ON o_im_roster_entry (r_resid, r_resname);
CREATE INDEX idx_im_rost_sub_idx ON o_im_roster_entry (r_resid, r_resname, r_ressubpath);

ALTER TABLE o_im_preferences ADD CONSTRAINT idx_im_prfs_to_id FOREIGN KEY (fk_from_identity_id) REFERENCES o_bs_identity (id);

-- efficiency statements
ALTER TABLE o_as_eff_statement ADD CONSTRAINT eff_statement_id_cstr FOREIGN KEY (fk_identity) REFERENCES o_bs_identity (id);
CREATE INDEX eff_statement_repo_key_idx ON o_as_eff_statement (course_repo_key);
CREATE INDEX idx_eff_stat_course_ident_idx ON o_as_eff_statement (fk_identity, course_repo_key);

-- course infos
ALTER TABLE o_as_user_course_infos ADD CONSTRAINT user_course_infos_id_cstr FOREIGN KEY (fk_identity) REFERENCES o_bs_identity (id);
CREATE INDEX user_course_infos_res_cstr ON o_as_user_course_infos (fk_resource_id);
ALTER TABLE o_as_user_course_infos ADD CONSTRAINT user_course_infos_res_cstr FOREIGN KEY (fk_resource_id) REFERENCES o_olatresource (resource_id);
ALTER TABLE o_as_user_course_infos ADD CONSTRAINT user_course_infos_unique UNIQUE (fk_identity, fk_resource_id);

ALTER TABLE o_as_entry ADD CONSTRAINT as_entry_to_identity_idx FOREIGN KEY (fk_identity) REFERENCES o_bs_identity (id);
ALTER TABLE o_as_entry ADD CONSTRAINT as_entry_to_entry_idx FOREIGN KEY (fk_entry) REFERENCES o_repositoryentry (repositoryentry_id);
ALTER TABLE o_as_entry ADD CONSTRAINT as_entry_to_refentry_idx FOREIGN KEY (fk_reference_entry) REFERENCES o_repositoryentry (repositoryentry_id);
ALTER TABLE o_as_entry ADD CONSTRAINT as_entry_to_coach_idx FOREIGN KEY (fk_coach) REFERENCES o_bs_identity (id);

CREATE INDEX idx_as_entry_to_id_idx ON o_as_entry (a_assessment_id);
CREATE INDEX idx_as_entry_start_idx ON o_as_entry (a_date_start);
CREATE INDEX idx_as_entry_subident_idx ON o_as_entry (a_subident, fk_entry, fk_identity);
CREATE INDEX idx_as_entry_re_status_idx ON o_as_entry (fk_entry, a_status);

ALTER TABLE o_as_score_accounting_trigger ADD CONSTRAINT satrigger_to_entry_idx FOREIGN KEY (fk_entry) REFERENCES o_repositoryentry (repositoryentry_id);
CREATE INDEX idx_satrigger_bs_group_idx ON o_as_score_accounting_trigger (e_business_group_key);
CREATE INDEX idx_satrigger_org_idx ON o_as_score_accounting_trigger (e_organisation_key);
CREATE INDEX idx_satrigger_curele_idx ON o_as_score_accounting_trigger (e_curriculum_element_key);
CREATE INDEX idx_satrigger_userprop_idx ON o_as_score_accounting_trigger (e_user_property_value, e_user_property_name);

-- Assessment message
ALTER TABLE o_as_message ADD CONSTRAINT as_msg_entry_idx FOREIGN KEY (fk_entry) REFERENCES o_repositoryentry (repositoryentry_id);

ALTER TABLE o_as_message_log ADD CONSTRAINT as_msg_log_identity_idx FOREIGN KEY (fk_identity) REFERENCES o_bs_identity (id);
ALTER TABLE o_as_message_log ADD CONSTRAINT as_msg_log_msg_idx FOREIGN KEY (fk_message) REFERENCES o_as_message (id);

-- disadvantage compensation
ALTER TABLE o_as_compensation ADD CONSTRAINT compensation_ident_idx FOREIGN KEY (fk_identity) REFERENCES o_bs_identity (id);
ALTER TABLE o_as_compensation ADD CONSTRAINT compensation_crea_idx FOREIGN KEY (fk_creator) REFERENCES o_bs_identity (id);
ALTER TABLE o_as_compensation ADD CONSTRAINT compensation_entry_idx FOREIGN KEY (fk_entry) REFERENCES o_repositoryentry (repositoryentry_id);

CREATE INDEX comp_log_entry_idx ON o_as_compensation_log (fk_entry_id);
CREATE INDEX comp_log_ident_idx ON o_as_compensation_log (fk_identity_id);

-- Grade
CREATE UNIQUE INDEX idx_grsys_ident ON o_gr_grade_system (g_identifier);
ALTER TABLE o_gr_grade_scale ADD CONSTRAINT grscale_to_entry_idx FOREIGN KEY (fk_grade_system) REFERENCES o_gr_grade_system (id);
ALTER TABLE o_gr_performance_class ADD CONSTRAINT perf_to_grsys_idx FOREIGN KEY (fk_grade_system) REFERENCES o_gr_grade_system (id);
ALTER TABLE o_gr_grade_scale ADD CONSTRAINT grscale_to_grsys_idx FOREIGN KEY (fk_entry) REFERENCES o_repositoryentry (repositoryentry_id);
ALTER TABLE o_gr_breakpoint ADD CONSTRAINT grbp_to_grsys_idx FOREIGN KEY (fk_grade_scale) REFERENCES o_gr_grade_scale (id);

-- gotomeeting
ALTER TABLE o_goto_organizer ADD CONSTRAINT goto_organ_owner_idx FOREIGN KEY (fk_identity) REFERENCES o_bs_identity (id);
CREATE INDEX idx_goto_organ_okey_idx ON o_goto_organizer (g_organizer_key);
CREATE INDEX idx_goto_organ_uname_idx ON o_goto_organizer (g_username);

ALTER TABLE o_goto_meeting ADD CONSTRAINT goto_meet_repoentry_idx FOREIGN KEY (fk_entry_id) REFERENCES o_repositoryentry (repositoryentry_id);
ALTER TABLE o_goto_meeting ADD CONSTRAINT goto_meet_busgrp_idx FOREIGN KEY (fk_group_id) REFERENCES o_gp_business (group_id);
ALTER TABLE o_goto_meeting ADD CONSTRAINT goto_meet_organizer_idx FOREIGN KEY (fk_organizer_id) REFERENCES o_goto_organizer (id);

ALTER TABLE o_goto_registrant ADD CONSTRAINT goto_regis_meeting_idx FOREIGN KEY (fk_meeting_id) REFERENCES o_goto_meeting (id);
ALTER TABLE o_goto_registrant ADD CONSTRAINT goto_regis_ident_idx FOREIGN KEY (fk_identity_id) REFERENCES o_bs_identity (id);

-- video
ALTER TABLE o_vid_transcoding ADD CONSTRAINT fk_resource_id_idx FOREIGN KEY (fk_resource_id) REFERENCES o_olatresource (resource_id);
CREATE INDEX vid_status_trans_idx ON o_vid_transcoding (vid_status);
CREATE INDEX vid_transcoder_trans_idx ON o_vid_transcoding (vid_transcoder);
ALTER TABLE o_vid_metadata ADD CONSTRAINT vid_meta_rsrc_idx FOREIGN KEY (fk_resource_id) REFERENCES o_olatresource (resource_id);

ALTER TABLE o_vid_to_organisation ADD CONSTRAINT vid_entry_to_entry_idx FOREIGN KEY (fk_entry) REFERENCES o_repositoryentry (repositoryentry_id);
ALTER TABLE o_vid_to_organisation ADD CONSTRAINT vid_entry_to_org_idx FOREIGN KEY (fk_organisation) REFERENCES o_org_organisation (id);

-- video task
ALTER TABLE o_vid_task_session ADD CONSTRAINT vid_sess_to_repo_entry_idx FOREIGN KEY (fk_entry) REFERENCES o_repositoryentry (repositoryentry_id);
ALTER TABLE o_vid_task_session ADD CONSTRAINT vid_sess_to_vid_entry_idx FOREIGN KEY (fk_reference_entry) REFERENCES o_repositoryentry (repositoryentry_id);
ALTER TABLE o_vid_task_session ADD CONSTRAINT vid_sess_to_identity_idx FOREIGN KEY (fk_identity) REFERENCES o_bs_identity (id);
ALTER TABLE o_vid_task_session ADD CONSTRAINT vid_sess_to_as_entry_idx FOREIGN KEY (fk_assessment_entry) REFERENCES o_as_entry (id);

ALTER TABLE o_vid_task_selection ADD CONSTRAINT vid_sel_to_session_idx FOREIGN KEY (fk_task_session) REFERENCES o_vid_task_session (id);

-- calendar
ALTER TABLE o_cal_use_config ADD CONSTRAINT cal_u_conf_to_ident_idx FOREIGN KEY (fk_identity) REFERENCES o_bs_identity (id);
CREATE INDEX idx_cal_u_conf_cal_id_idx ON o_cal_use_config (c_calendar_id);
CREATE INDEX idx_cal_u_conf_cal_type_idx ON o_cal_use_config (c_calendar_type);

ALTER TABLE o_cal_import ADD CONSTRAINT cal_imp_to_ident_idx FOREIGN KEY (fk_identity) REFERENCES o_bs_identity (id);
CREATE INDEX idx_cal_imp_cal_id_idx ON o_cal_import (c_calendar_id);
CREATE INDEX idx_cal_imp_cal_type_idx ON o_cal_import (c_calendar_type);

CREATE INDEX idx_cal_imp_to_cal_id_idx ON o_cal_import_to (c_to_calendar_id);
CREATE INDEX idx_cal_imp_to_cal_type_idx ON o_cal_import_to (c_to_calendar_type);

-- mapper
CREATE INDEX o_mapper_uuid_idx ON o_mapper (mapper_uuid);


-- qti 2.1
ALTER TABLE o_qti_assessmenttest_session ADD CONSTRAINT qti_sess_to_repo_entry_idx FOREIGN KEY (fk_entry) REFERENCES o_repositoryentry (repositoryentry_id);
ALTER TABLE o_qti_assessmenttest_session ADD CONSTRAINT qti_sess_to_course_entry_idx FOREIGN KEY (fk_reference_entry) REFERENCES o_repositoryentry (repositoryentry_id);
ALTER TABLE o_qti_assessmenttest_session ADD CONSTRAINT qti_sess_to_identity_idx FOREIGN KEY (fk_identity) REFERENCES o_bs_identity (id);
ALTER TABLE o_qti_assessmenttest_session ADD CONSTRAINT qti_sess_to_as_entry_idx FOREIGN KEY (fk_assessment_entry) REFERENCES o_as_entry (id);

ALTER TABLE o_qti_assessmentitem_session ADD CONSTRAINT qti_itemsess_to_testsess_idx FOREIGN KEY (fk_assessmenttest_session) REFERENCES o_qti_assessmenttest_session (id);
CREATE INDEX idx_item_identifier_idx ON o_qti_assessmentitem_session (q_itemidentifier);

ALTER TABLE o_qti_assessment_response ADD CONSTRAINT qti_resp_to_testsession_idx FOREIGN KEY (fk_assessmenttest_session) REFERENCES o_qti_assessmenttest_session (id);
ALTER TABLE o_qti_assessment_response ADD CONSTRAINT qti_resp_to_itemsession_idx FOREIGN KEY (fk_assessmentitem_session) REFERENCES o_qti_assessmentitem_session (id);
CREATE INDEX idx_response_identifier_idx ON o_qti_assessment_response (q_responseidentifier);
CREATE INDEX idx_item_ext_ref_idx ON o_qti_assessmentitem_session (q_externalrefidentifier);

ALTER TABLE o_qti_assessment_marks ADD CONSTRAINT qti_marks_to_repo_entry_idx FOREIGN KEY (fk_entry) REFERENCES o_repositoryentry (repositoryentry_id);
ALTER TABLE o_qti_assessment_marks ADD CONSTRAINT qti_marks_to_course_entry_idx FOREIGN KEY (fk_reference_entry) REFERENCES o_repositoryentry (repositoryentry_id);
ALTER TABLE o_qti_assessment_marks ADD CONSTRAINT qti_marks_to_identity_idx FOREIGN KEY (fk_identity) REFERENCES o_bs_identity (id);

-- Practice
ALTER TABLE o_practice_resource ADD CONSTRAINT pract_entry_idx FOREIGN KEY (fk_entry) REFERENCES o_repositoryentry (repositoryentry_id);
ALTER TABLE o_practice_resource ADD CONSTRAINT pract_test_entry_idx FOREIGN KEY (fk_test_entry) REFERENCES o_repositoryentry (repositoryentry_id);
ALTER TABLE o_practice_resource ADD CONSTRAINT pract_item_coll_idx FOREIGN KEY (fk_item_collection) REFERENCES o_qp_item_collection (id);
ALTER TABLE o_practice_resource ADD CONSTRAINT pract_poll_idx FOREIGN KEY (fk_pool) REFERENCES o_qp_pool (id);
ALTER TABLE o_practice_resource ADD CONSTRAINT pract_rsrc_share_idx FOREIGN KEY (fk_resource_share) REFERENCES o_olatresource(resource_id);

ALTER TABLE o_practice_global_item_ref ADD CONSTRAINT pract_global_ident_idx FOREIGN KEY (fk_identity) REFERENCES o_bs_identity(id);

CREATE INDEX idx_pract_global_id_uu_idx ON o_practice_global_item_ref (fk_identity, p_identifier);

-- portfolio
ALTER TABLE o_pf_binder ADD CONSTRAINT pf_binder_resource_idx FOREIGN KEY (fk_olatresource_id) REFERENCES o_olatresource (resource_id);
ALTER TABLE o_pf_binder ADD CONSTRAINT pf_binder_group_idx FOREIGN KEY (fk_group_id) REFERENCES o_bs_group (id);
ALTER TABLE o_pf_binder ADD CONSTRAINT pf_binder_course_idx FOREIGN KEY (fk_entry_id) REFERENCES o_repositoryentry (repositoryentry_id);
ALTER TABLE o_pf_binder ADD CONSTRAINT pf_binder_template_idx FOREIGN KEY (fk_template_id) REFERENCES o_pf_binder (id);

ALTER TABLE o_pf_section ADD CONSTRAINT pf_section_group_idx FOREIGN KEY (fk_group_id) REFERENCES o_bs_group (id);
ALTER TABLE o_pf_section ADD CONSTRAINT pf_section_binder_idx FOREIGN KEY (fk_binder_id) REFERENCES o_pf_binder (id);
ALTER TABLE o_pf_section ADD CONSTRAINT pf_section_template_idx FOREIGN KEY (fk_template_reference_id) REFERENCES o_pf_section (id);

ALTER TABLE o_ce_page ADD CONSTRAINT pf_page_group_idx FOREIGN KEY (fk_group_id) REFERENCES o_bs_group (id);
ALTER TABLE o_ce_page ADD CONSTRAINT pf_page_section_idx FOREIGN KEY (fk_section_id) REFERENCES o_pf_section (id);
ALTER TABLE o_ce_page ADD CONSTRAINT pf_page_body_idx FOREIGN KEY (fk_body_id) REFERENCES o_ce_page_body (id);
ALTER TABLE o_ce_page ADD CONSTRAINT page_preview_metadata_idx FOREIGN KEY (fk_preview_metadata) REFERENCES o_vfs_metadata(id);

ALTER TABLE o_media ADD CONSTRAINT pf_media_author_idx FOREIGN KEY (fk_author_id) REFERENCES o_bs_identity (id);
CREATE INDEX idx_category_rel_resid_idx ON o_media (p_business_path);

ALTER TABLE o_media_tag ADD CONSTRAINT media_tag_media_idx FOREIGN KEY (fk_media) REFERENCES o_media (id);
ALTER TABLE o_media_tag ADD CONSTRAINT media_tag_tag_idx FOREIGN KEY (fk_tag) REFERENCES o_tag_tag (id);

ALTER TABLE o_media_to_tax_level ADD CONSTRAINT media_tax_media_idx FOREIGN KEY (fk_media) REFERENCES o_media (id);
ALTER TABLE o_media_to_tax_level ADD CONSTRAINT media_tax_tax_idx FOREIGN KEY (fk_taxonomy_level) REFERENCES o_tax_taxonomy_level (id);

ALTER TABLE o_media_to_group ADD CONSTRAINT med_to_group_media_idx FOREIGN KEY (fk_media) REFERENCES o_media (id);
ALTER TABLE o_media_to_group ADD CONSTRAINT med_to_group_group_idx FOREIGN KEY (fk_group) REFERENCES o_bs_group (id);
ALTER TABLE o_media_to_group ADD CONSTRAINT med_to_group_re_idx FOREIGN KEY (fk_repositoryentry) REFERENCES o_repositoryentry (repositoryentry_id);

ALTER TABLE o_media_version ADD CONSTRAINT media_version_media_idx FOREIGN KEY (fk_media) REFERENCES o_media (id);
ALTER TABLE o_media_version ADD CONSTRAINT media_version_meta_idx FOREIGN KEY (fk_metadata) REFERENCES o_vfs_metadata (id);
ALTER TABLE o_media_version ADD CONSTRAINT media_version_version_metadata_idx FOREIGN KEY (fk_version_metadata) REFERENCES o_media_version_metadata(id);
CREATE INDEX idx_media_version_uuid_idx ON o_media_version (p_version_uuid);
CREATE INDEX idx_media_version_checksum_idx ON o_media_version (p_version_checksum);

ALTER TABLE o_media_log ADD CONSTRAINT media_log_media_idx FOREIGN KEY (fk_media) REFERENCES o_media (id);
ALTER TABLE o_media_log ADD CONSTRAINT media_log_ident_idx FOREIGN KEY (fk_identity) REFERENCES o_bs_identity (id);

ALTER TABLE o_ce_page_reference ADD CONSTRAINT page_ref_to_page_idx FOREIGN KEY (fk_page) REFERENCES o_ce_page (id);
ALTER TABLE o_ce_page_reference ADD CONSTRAINT page_ref_to_entry_idx FOREIGN KEY (fk_entry) REFERENCES o_repositoryentry (repositoryentry_id);

ALTER TABLE o_ce_page_part ADD CONSTRAINT media_part_version_idx FOREIGN KEY (fk_media_version_id) REFERENCES o_media_version (id);
ALTER TABLE o_ce_page_part ADD CONSTRAINT pf_page_page_body_idx FOREIGN KEY (fk_page_body_id) REFERENCES o_ce_page_body (id);
ALTER TABLE o_ce_page_part ADD CONSTRAINT pf_page_media_idx FOREIGN KEY (fk_media_id) REFERENCES o_media (id);
ALTER TABLE o_ce_page_part ADD CONSTRAINT pf_part_form_idx FOREIGN KEY (fk_form_entry_id) REFERENCES o_repositoryentry (repositoryentry_id);
ALTER TABLE o_ce_page_part ADD CONSTRAINT media_part_ident_idx FOREIGN KEY (fk_identity_id) REFERENCES o_bs_identity (id);

CREATE INDEX idx_category_name_idx ON o_pf_category (p_name);

ALTER TABLE o_pf_category_relation ADD CONSTRAINT pf_category_rel_cat_idx FOREIGN KEY (fk_category_id) REFERENCES o_pf_category (id);
CREATE INDEX idx_category_rel_resid_idx ON o_pf_category_relation (p_resid);

ALTER TABLE o_pf_assessment_section ADD CONSTRAINT pf_asection_section_idx FOREIGN KEY (fk_section_id) REFERENCES o_pf_section (id);
ALTER TABLE o_pf_assessment_section ADD CONSTRAINT pf_asection_ident_idx FOREIGN KEY (fk_identity_id) REFERENCES o_bs_identity (id);

ALTER TABLE o_ce_assignment ADD CONSTRAINT pf_assign_section_idx FOREIGN KEY (fk_section_id) REFERENCES o_pf_section (id);
ALTER TABLE o_ce_assignment ADD CONSTRAINT pf_assign_binder_idx FOREIGN KEY (fk_binder_id) REFERENCES o_pf_binder (id);
ALTER TABLE o_ce_assignment ADD CONSTRAINT pf_assign_ref_assign_idx FOREIGN KEY (fk_template_reference_id) REFERENCES o_ce_assignment (id);
ALTER TABLE o_ce_assignment ADD CONSTRAINT pf_assign_page_idx FOREIGN KEY (fk_page_id) REFERENCES o_ce_page (id);
ALTER TABLE o_ce_assignment ADD CONSTRAINT pf_assign_assignee_idx FOREIGN KEY (fk_assignee_id) REFERENCES o_bs_identity (id);
ALTER TABLE o_ce_assignment ADD CONSTRAINT pf_assign_form_idx FOREIGN KEY (fk_form_entry_id) REFERENCES o_repositoryentry (repositoryentry_id);

ALTER TABLE o_pf_binder_user_infos ADD CONSTRAINT binder_user_to_identity_idx FOREIGN KEY (fk_identity) REFERENCES o_bs_identity (id);
ALTER TABLE o_pf_binder_user_infos ADD CONSTRAINT binder_user_binder_idx FOREIGN KEY (fk_binder) REFERENCES o_pf_binder (id);

ALTER TABLE o_ce_page_user_infos ADD CONSTRAINT user_pfpage_idx FOREIGN KEY (fk_identity_id) REFERENCES o_bs_identity (id);
ALTER TABLE o_ce_page_user_infos ADD CONSTRAINT page_pfpage_idx FOREIGN KEY (fk_page_id) REFERENCES o_ce_page (id);

ALTER TABLE o_ce_audit_log ADD CONSTRAINT ce_log_to_doer_idx FOREIGN KEY (fk_doer) REFERENCES o_bs_identity (id);
CREATE INDEX idx_ce_log_to_page_idx ON o_ce_audit_log (fk_page);


-- Evaluation form
ALTER TABLE o_eva_form_survey ADD CONSTRAINT eva_surv_to_surv_idx FOREIGN KEY (fk_series_previous) REFERENCES o_eva_form_survey (id);
CREATE INDEX idx_eva_surv_ores_idx ON o_eva_form_survey (e_resid, e_resname);

ALTER TABLE o_eva_form_participation ADD CONSTRAINT eva_part_to_surv_idx FOREIGN KEY (fk_survey) REFERENCES o_eva_form_survey (id);
CREATE UNIQUE INDEX idx_eva_part_ident_idx ON o_eva_form_participation (e_identifier_key, e_identifier_type, fk_survey);
CREATE UNIQUE INDEX idx_eva_part_executor_idx ON o_eva_form_participation (fk_executor, fk_survey);

ALTER TABLE o_eva_form_session ADD CONSTRAINT eva_sess_to_surv_idx FOREIGN KEY (fk_survey) REFERENCES o_eva_form_survey (id);
ALTER TABLE o_eva_form_session ADD CONSTRAINT eva_sess_to_part_idx FOREIGN KEY (fk_participation) REFERENCES o_eva_form_participation (id);
ALTER TABLE o_eva_form_session ADD CONSTRAINT eva_sess_to_ident_idx FOREIGN KEY (fk_identity) REFERENCES o_bs_identity (id);
ALTER TABLE o_eva_form_session ADD CONSTRAINT eva_sess_to_body_idx FOREIGN KEY (fk_page_body) REFERENCES o_ce_page_body (id);
ALTER TABLE o_eva_form_session ADD CONSTRAINT eva_sess_to_form_idx FOREIGN KEY (fk_form_entry) REFERENCES o_repositoryentry (repositoryentry_id);

ALTER TABLE o_eva_form_response ADD CONSTRAINT eva_resp_to_sess_idx FOREIGN KEY (fk_session) REFERENCES o_eva_form_session (id);
CREATE INDEX idx_eva_resp_report_idx ON o_eva_form_response (fk_session, e_responseidentifier, e_no_response);

ALTER TABLE o_ce_page_to_tax_competence ADD CONSTRAINT fk_tax_competence_idx FOREIGN KEY (fk_tax_competence) REFERENCES o_tax_taxonomy_competence (id);
ALTER TABLE o_ce_page_to_tax_competence ADD CONSTRAINT fk_pf_page_idx FOREIGN KEY (fk_pf_page) REFERENCES o_ce_page (id);

-- VFS metadata
ALTER TABLE o_vfs_metadata ADD CONSTRAINT fmeta_to_author_idx FOREIGN KEY (fk_locked_identity) REFERENCES o_bs_identity (id);
ALTER TABLE o_vfs_metadata ADD CONSTRAINT fmeta_modified_by_idx FOREIGN KEY (fk_lastmodified_by) REFERENCES o_bs_identity (id);
ALTER TABLE o_vfs_metadata ADD CONSTRAINT fmeta_to_lockid_idx FOREIGN KEY (fk_initialized_by) REFERENCES o_bs_identity (id);
ALTER TABLE o_vfs_metadata ADD CONSTRAINT fmeta_to_lic_type_idx FOREIGN KEY (fk_license_type) REFERENCES o_lic_license_type (id);
ALTER TABLE o_vfs_metadata ADD CONSTRAINT fmeta_to_parent_idx FOREIGN KEY (fk_parent) REFERENCES o_vfs_metadata (id);

-- Creating computed columns for indexing
ALTER TABLE o_vfs_metadata ADD f_relative_path_computed AS LEFT(f_relative_path, 255) PERSISTED;
ALTER TABLE o_vfs_metadata ADD f_filename_computed AS LEFT(f_filename, 255) PERSISTED;
CREATE INDEX f_m_rel_path_idx ON o_vfs_metadata (f_relative_path_computed);
CREATE INDEX f_m_file_idx ON o_vfs_metadata (f_relative_path_computed, f_filename_computed);
CREATE INDEX f_m_uuid_idx ON o_vfs_metadata (f_uuid);
CREATE INDEX f_exp_date_idx ON o_vfs_metadata (f_expiration_date);

ALTER TABLE o_vfs_thumbnail ADD CONSTRAINT fthumb_to_meta_idx FOREIGN KEY (fk_metadata) REFERENCES o_vfs_metadata (id);

ALTER TABLE o_vfs_revision ADD CONSTRAINT fvers_to_author_idx FOREIGN KEY (fk_initialized_by) REFERENCES o_bs_identity (id);
ALTER TABLE o_vfs_revision ADD CONSTRAINT fvers_modified_by_idx FOREIGN KEY (fk_lastmodified_by) REFERENCES o_bs_identity (id);
ALTER TABLE o_vfs_revision ADD CONSTRAINT fvers_to_meta_idx FOREIGN KEY (fk_metadata) REFERENCES o_vfs_metadata (id);
ALTER TABLE o_vfs_revision ADD CONSTRAINT fvers_to_lic_type_idx FOREIGN KEY (fk_license_type) REFERENCES o_lic_license_type (id);

CREATE INDEX idx_vfs_meta_transstat_idx ON o_vfs_metadata (f_transcoding_status);

-- Document editor
CREATE UNIQUE INDEX idx_de_userinfo_ident_idx ON o_de_user_info (fk_identity);

-- Quality management
ALTER TABLE o_qual_data_collection ADD CONSTRAINT qual_dc_to_gen_idx FOREIGN KEY (fk_generator) REFERENCES o_qual_generator (id);
CREATE INDEX idx_dc_status_idx ON o_qual_data_collection (q_status);

ALTER TABLE o_qual_data_collection_to_org ADD CONSTRAINT qual_dc_to_org_idx FOREIGN KEY (fk_data_collection) REFERENCES o_qual_data_collection (id);
CREATE UNIQUE INDEX idx_qual_dc_to_org_idx ON o_qual_data_collection_to_org (fk_data_collection, fk_organisation);

ALTER TABLE o_qual_context ADD CONSTRAINT qual_con_to_data_collection_idx FOREIGN KEY (fk_data_collection) REFERENCES o_qual_data_collection (id);
ALTER TABLE o_qual_context ADD CONSTRAINT qual_con_to_participation_idx FOREIGN KEY (fk_eva_participation) REFERENCES o_eva_form_participation (id);
ALTER TABLE o_qual_context ADD CONSTRAINT qual_con_to_session_idx FOREIGN KEY (fk_eva_session) REFERENCES o_eva_form_session (id);

ALTER TABLE o_qual_context_to_organisation ADD CONSTRAINT qual_con_to_org_con_idx FOREIGN KEY (fk_context) REFERENCES o_qual_context (id);
CREATE UNIQUE INDEX idx_con_to_org_org_idx ON o_qual_context_to_organisation (fk_organisation, fk_context);

ALTER TABLE o_qual_context_to_curriculum ADD CONSTRAINT qual_con_to_cur_con_idx FOREIGN KEY (fk_context) REFERENCES o_qual_context (id);
CREATE UNIQUE INDEX idx_con_to_cur_cur_idx ON o_qual_context_to_curriculum (fk_curriculum, fk_context);

ALTER TABLE o_qual_context_to_cur_element ADD CONSTRAINT qual_con_to_cur_ele_con_idx FOREIGN KEY (fk_context) REFERENCES o_qual_context (id);
CREATE UNIQUE INDEX idx_con_to_cur_ele_ele_idx ON o_qual_context_to_cur_element (fk_cur_element, fk_context);

ALTER TABLE o_qual_context_to_tax_level ADD CONSTRAINT qual_con_to_tax_level_con_idx FOREIGN KEY (fk_context) REFERENCES o_qual_context (id);
CREATE UNIQUE INDEX idx_con_to_tax_level_tax_idx ON o_qual_context_to_tax_level (fk_tax_leveL, fk_context);

ALTER TABLE o_qual_reminder ADD CONSTRAINT qual_rem_to_data_collection_idx FOREIGN KEY (fk_data_collection) REFERENCES o_qual_data_collection (id);

ALTER TABLE o_qual_report_access ADD CONSTRAINT qual_repacc_to_dc_idx FOREIGN KEY (fk_data_collection) REFERENCES o_qual_data_collection (id);
ALTER TABLE o_qual_report_access ADD CONSTRAINT qual_repacc_to_generator_idx FOREIGN KEY (fk_generator) REFERENCES o_qual_generator (id);

ALTER TABLE o_qual_generator_to_org ADD CONSTRAINT qual_gen_to_org_idx FOREIGN KEY (fk_generator) REFERENCES o_qual_generator (id);
CREATE UNIQUE INDEX idx_qual_gen_to_org_idx ON o_qual_generator_to_org (fk_generator, fk_organisation);

ALTER TABLE o_qual_generator_override ADD CONSTRAINT qual_override_to_gen_idx FOREIGN KEY (fk_generator) REFERENCES o_qual_generator (id);
ALTER TABLE o_qual_generator_override ADD CONSTRAINT qual_override_to_dc_idx FOREIGN KEY (fk_data_collection) REFERENCES o_qual_data_collection (id);
CREATE INDEX idx_override_ident_idx ON o_qual_generator_override (q_identifier);

CREATE INDEX idx_qm_audit_doer_idx ON o_qual_audit_log (fk_doer);
CREATE INDEX idx_qm_audit_dc_idx ON o_qual_audit_log (fk_data_collection);
CREATE INDEX idx_qm_audit_todo_idx ON o_qual_audit_log (fk_todo_task);
CREATE INDEX idx_qm_audit_ident_idx ON o_qual_audit_log (fk_identity);

-- Question pool
ALTER TABLE o_qp_pool ADD CONSTRAINT idx_qp_pool_owner_grp_id FOREIGN KEY (fk_ownergroup) REFERENCES o_bs_secgroup (id);

ALTER TABLE o_qp_pool_2_item ADD CONSTRAINT idx_qp_pool_2_item_pool_id FOREIGN KEY (fk_pool_id) REFERENCES o_qp_pool (id);
ALTER TABLE o_qp_pool_2_item ADD CONSTRAINT idx_qp_pool_2_item_item_id FOREIGN KEY (fk_item_id) REFERENCES o_qp_item (id);
ALTER TABLE o_qp_pool_2_item ADD UNIQUE (fk_pool_id, fk_item_id);

ALTER TABLE o_qp_share_item ADD CONSTRAINT idx_qp_share_rsrc_id FOREIGN KEY (fk_resource_id) REFERENCES o_olatresource (resource_id);
ALTER TABLE o_qp_share_item ADD CONSTRAINT idx_qp_share_item_id FOREIGN KEY (fk_item_id) REFERENCES o_qp_item (id);
ALTER TABLE o_qp_share_item ADD UNIQUE (fk_resource_id, fk_item_id);

ALTER TABLE o_qp_item_collection ADD CONSTRAINT idx_qp_coll_owner_id FOREIGN KEY (fk_owner_id) REFERENCES o_bs_identity (id);

ALTER TABLE o_qp_collection_2_item ADD CONSTRAINT idx_qp_coll_coll_id FOREIGN KEY (fk_collection_id) REFERENCES o_qp_item_collection (id);
ALTER TABLE o_qp_collection_2_item ADD CONSTRAINT idx_qp_coll_item_id FOREIGN KEY (fk_item_id) REFERENCES o_qp_item (id);
ALTER TABLE o_qp_collection_2_item ADD UNIQUE (fk_collection_id, fk_item_id);

ALTER TABLE o_qp_item ADD CONSTRAINT idx_qp_pool_2_tax_id FOREIGN KEY (fk_taxonomy_level_v2) REFERENCES o_tax_taxonomy_level (id);
ALTER TABLE o_qp_item ADD CONSTRAINT idx_qp_item_owner_id FOREIGN KEY (fk_ownergroup) REFERENCES o_bs_secgroup (id);
ALTER TABLE o_qp_item ADD CONSTRAINT idx_qp_item_edu_ctxt_id FOREIGN KEY (fk_edu_context) REFERENCES o_qp_edu_context (id);
ALTER TABLE o_qp_item ADD CONSTRAINT idx_qp_item_type_id FOREIGN KEY (fk_type) REFERENCES o_qp_item_type (id);
ALTER TABLE o_qp_item ADD CONSTRAINT idx_qp_item_license_id FOREIGN KEY (fk_license) REFERENCES o_qp_license (id);

ALTER TABLE o_qp_taxonomy_level ADD CONSTRAINT idx_qp_field_2_parent_id FOREIGN KEY (fk_parent_field) REFERENCES o_qp_taxonomy_level (id);

-- Creating computed column for indexing
ALTER TABLE o_qp_taxonomy_level ADD q_mat_path_ids_computed AS LEFT(q_mat_path_ids, 255) PERSISTED;
CREATE INDEX idx_taxon_mat_pathon ON o_qp_taxonomy_level (q_mat_path_ids_computed);

ALTER TABLE o_qp_item_type ADD UNIQUE (q_type);
CREATE INDEX idx_item_audit_item_idx ON o_qp_item_audit_log (fk_item_id);

-- LTI
ALTER TABLE o_lti_outcome ADD CONSTRAINT idx_lti_outcome_ident_id FOREIGN KEY (fk_identity_id) REFERENCES o_bs_identity (id);
ALTER TABLE o_lti_outcome ADD CONSTRAINT idx_lti_outcome_rsrc_id FOREIGN KEY (fk_resource_id) REFERENCES o_olatresource (resource_id);

-- LTI 1.3
ALTER TABLE o_lti_tool_deployment ADD CONSTRAINT lti_sdep_to_tool_idx FOREIGN KEY (fk_tool_id) REFERENCES o_lti_tool (id);
ALTER TABLE o_lti_tool_deployment ADD CONSTRAINT lti_sdep_to_re_idx FOREIGN KEY (fk_entry_id) REFERENCES o_repositoryentry (repositoryentry_id);
ALTER TABLE o_lti_tool_deployment ADD CONSTRAINT dep_to_group_idx FOREIGN KEY (fk_group_id) REFERENCES o_gp_business (group_id);

ALTER TABLE o_lti_context ADD CONSTRAINT ltictx_to_deploy_idx FOREIGN KEY (fk_deployment_id) REFERENCES o_lti_tool_deployment (id);
ALTER TABLE o_lti_context ADD CONSTRAINT lti_ctxt_to_re_idx FOREIGN KEY (fk_entry_id) REFERENCES o_repositoryentry (repositoryentry_id);
ALTER TABLE o_lti_context ADD CONSTRAINT ctxt_to_group_idx FOREIGN KEY (fk_group_id) REFERENCES o_gp_business (group_id);

ALTER TABLE o_lti_shared_tool_deployment ADD CONSTRAINT unique_deploy_platform UNIQUE (l_deployment_id, fk_platform_id);
ALTER TABLE o_lti_shared_tool_deployment ADD CONSTRAINT lti_sha_dep_to_tool_idx FOREIGN KEY (fk_platform_id) REFERENCES o_lti_platform (id);
ALTER TABLE o_lti_shared_tool_deployment ADD CONSTRAINT lti_shared_to_re_idx FOREIGN KEY (fk_entry_id) REFERENCES o_repositoryentry (repositoryentry_id);
ALTER TABLE o_lti_shared_tool_deployment ADD CONSTRAINT lti_shared_to_bg_idx FOREIGN KEY (fk_group_id) REFERENCES o_gp_business (group_id);

ALTER TABLE o_lti_shared_tool_service ADD CONSTRAINT lti_sha_ser_to_dep_idx FOREIGN KEY (fk_deployment_id) REFERENCES o_lti_shared_tool_deployment (id);

ALTER TABLE o_lti_content_item ADD CONSTRAINT ltiitem_to_tool_idx FOREIGN KEY (fk_tool_id) REFERENCES o_lti_tool (id);
ALTER TABLE o_lti_content_item ADD CONSTRAINT ltiitem_to_deploy_idx FOREIGN KEY (fk_tool_deployment_id) REFERENCES o_lti_tool_deployment (id);
ALTER TABLE o_lti_content_item ADD CONSTRAINT ltiitem_to_context_idx FOREIGN KEY (fk_context_id) REFERENCES o_lti_context (id);

CREATE INDEX idx_lti_kid_idx ON o_lti_key (l_key_id);

-- Assessment mode
ALTER TABLE o_as_mode_course ADD CONSTRAINT as_mode_to_repo_entry_idx FOREIGN KEY (fk_entry) REFERENCES o_repositoryentry (repositoryentry_id);
ALTER TABLE o_as_mode_course ADD CONSTRAINT as_mode_to_lblock_idx FOREIGN KEY (fk_lecture_block) REFERENCES o_lecture_block (id);

ALTER TABLE o_as_mode_course_to_group ADD CONSTRAINT as_modetogroup_group_idx FOREIGN KEY (fk_group_id) REFERENCES o_gp_business (group_id);
ALTER TABLE o_as_mode_course_to_group ADD CONSTRAINT as_modetogroup_mode_idx FOREIGN KEY (fk_assessment_mode_id) REFERENCES o_as_mode_course (id);

ALTER TABLE o_as_mode_course_to_area ADD CONSTRAINT as_modetoarea_area_idx FOREIGN KEY (fk_area_id) REFERENCES o_gp_bgarea (area_id);
ALTER TABLE o_as_mode_course_to_area ADD CONSTRAINT as_modetoarea_mode_idx FOREIGN KEY (fk_assessment_mode_id) REFERENCES o_as_mode_course (id);

ALTER TABLE o_as_mode_course_to_cur_el ADD CONSTRAINT as_modetocur_el_idx FOREIGN KEY (fk_cur_element_id) REFERENCES o_cur_curriculum_element (id);
ALTER TABLE o_as_mode_course_to_cur_el ADD CONSTRAINT as_modetocur_mode_idx FOREIGN KEY (fk_assessment_mode_id) REFERENCES o_as_mode_course (id);

-- Assessment inspection
ALTER TABLE o_as_inspection_configuration ADD CONSTRAINT as_insp_to_repo_entry_idx FOREIGN KEY (fk_entry) REFERENCES o_repositoryentry (repositoryentry_id);

ALTER TABLE o_as_inspection ADD CONSTRAINT as_insp_to_ident_idx FOREIGN KEY (fk_identity) REFERENCES o_bs_identity (id);
ALTER TABLE o_as_inspection ADD CONSTRAINT as_insp_to_config_idx FOREIGN KEY (fk_configuration) REFERENCES o_as_inspection_configuration (id);
CREATE INDEX idx_as_insp_subident_idx ON o_as_inspection (a_subident);
CREATE INDEX idx_as_insp_endtime_idx ON o_as_inspection (a_end_time);
CREATE INDEX idx_as_insp_fromto_idx ON o_as_inspection (a_from, a_to);

ALTER TABLE o_as_inspection_log ADD CONSTRAINT as_insp_log_to_ident_idx FOREIGN KEY (fk_doer) REFERENCES o_bs_identity (id);
ALTER TABLE o_as_inspection_log ADD CONSTRAINT as_log_to_insp_idx FOREIGN KEY (fk_inspection) REFERENCES o_as_inspection (id);

-- Certificate
ALTER TABLE o_cer_certificate ADD CONSTRAINT cer_to_identity_idx FOREIGN KEY (fk_identity) REFERENCES o_bs_identity (id);
ALTER TABLE o_cer_certificate ADD CONSTRAINT cer_to_resource_idx FOREIGN KEY (fk_olatresource) REFERENCES o_olatresource (resource_id);
ALTER TABLE o_cer_certificate ADD CONSTRAINT certificate_metadata_idx FOREIGN KEY (fk_metadata) REFERENCES o_vfs_metadata (id);

CREATE INDEX cer_archived_resource_idx ON o_cer_certificate (c_archived_resource_id);
CREATE INDEX cer_uuid_idx ON o_cer_certificate (c_uuid);

ALTER TABLE o_cer_entry_config ADD CONSTRAINT cer_entry_config_entry_idx FOREIGN KEY (fk_entry) REFERENCES o_repositoryentry (repositoryentry_id);
ALTER TABLE o_cer_entry_config ADD CONSTRAINT template_config_entry_idx FOREIGN KEY (fk_template) REFERENCES o_cer_template (id);

-- SMS
ALTER TABLE o_sms_message_log ADD CONSTRAINT sms_log_to_identity_idx FOREIGN KEY (fk_identity) REFERENCES o_bs_identity (id);

-- Webfeed
CREATE INDEX idx_feed_resourceable_idx ON o_feed (f_resourceable_id, f_resourceable_type);
ALTER TABLE o_feed_item ADD CONSTRAINT item_to_feed_fk FOREIGN KEY (fk_feed_id) REFERENCES o_feed (id);
CREATE INDEX idx_item_feed_idx ON o_feed_item (fk_feed_id);
ALTER TABLE o_feed_item ADD CONSTRAINT feed_item_to_ident_author_fk FOREIGN KEY (fk_identity_author_id) REFERENCES o_bs_identity (id);
CREATE INDEX idx_item_ident_author_idx ON o_feed_item (fk_identity_author_id);
ALTER TABLE o_feed_item ADD CONSTRAINT feed_item_to_ident_modified_fk FOREIGN KEY (fk_identity_modified_id) REFERENCES o_bs_identity (id);
CREATE INDEX idx_item_ident_modified_idx ON o_feed_item (fk_identity_modified_id);

-- Lecture
ALTER TABLE o_lecture_block ADD CONSTRAINT lec_block_entry_idx FOREIGN KEY (fk_entry) REFERENCES o_repositoryentry (repositoryentry_id);
ALTER TABLE o_lecture_block ADD CONSTRAINT lec_block_gcoach_idx FOREIGN KEY (fk_teacher_group) REFERENCES o_bs_group (id);
ALTER TABLE o_lecture_block ADD CONSTRAINT lec_block_reason_idx FOREIGN KEY (fk_reason) REFERENCES o_lecture_reason (id);

ALTER TABLE o_lecture_block_roll_call ADD CONSTRAINT absence_category_idx FOREIGN KEY (fk_absence_category) REFERENCES o_lecture_absence_category (id);

ALTER TABLE o_lecture_absence_notice ADD CONSTRAINT notice_identity_idx FOREIGN KEY (fk_identity) REFERENCES o_bs_identity (id);
ALTER TABLE o_lecture_absence_notice ADD CONSTRAINT notice_notif_identity_idx FOREIGN KEY (fk_notifier) REFERENCES o_bs_identity (id);
ALTER TABLE o_lecture_absence_notice ADD CONSTRAINT notice_auth_identity_idx FOREIGN KEY (fk_authorizer) REFERENCES o_bs_identity (id);
ALTER TABLE o_lecture_absence_notice ADD CONSTRAINT notice_category_idx FOREIGN KEY (fk_absence_category) REFERENCES o_lecture_absence_category (id);

ALTER TABLE o_lecture_notice_to_block ADD CONSTRAINT notice_to_block_idx FOREIGN KEY (fk_lecture_block) REFERENCES o_lecture_block (id);
ALTER TABLE o_lecture_notice_to_block ADD CONSTRAINT notice_to_notice_idx FOREIGN KEY (fk_absence_notice) REFERENCES o_lecture_absence_notice (id);

ALTER TABLE o_lecture_notice_to_entry ADD CONSTRAINT notice_to_entry_idx FOREIGN KEY (fk_entry) REFERENCES o_repositoryentry (repositoryentry_id);
ALTER TABLE o_lecture_notice_to_entry ADD CONSTRAINT rel_notice_e_to_notice_idx FOREIGN KEY (fk_absence_notice) REFERENCES o_lecture_absence_notice (id);

ALTER TABLE o_lecture_block_to_group ADD CONSTRAINT lec_block_to_block_idx FOREIGN KEY (fk_group) REFERENCES o_bs_group (id);
ALTER TABLE o_lecture_block_to_group ADD CONSTRAINT lec_block_to_group_idx FOREIGN KEY (fk_lecture_block) REFERENCES o_lecture_block (id);

ALTER TABLE o_lecture_block_roll_call ADD CONSTRAINT lec_call_block_idx FOREIGN KEY (fk_lecture_block) REFERENCES o_lecture_block (id);
ALTER TABLE o_lecture_block_roll_call ADD CONSTRAINT lec_call_identity_idx FOREIGN KEY (fk_identity) REFERENCES o_bs_identity (id);
ALTER TABLE o_lecture_block_roll_call ADD CONSTRAINT rollcall_to_notice_idx FOREIGN KEY (fk_absence_notice) REFERENCES o_lecture_absence_notice (id);

ALTER TABLE o_lecture_reminder ADD CONSTRAINT lec_reminder_block_idx FOREIGN KEY (fk_lecture_block) REFERENCES o_lecture_block (id);
ALTER TABLE o_lecture_reminder ADD CONSTRAINT lec_reminder_identity_idx FOREIGN KEY (fk_identity) REFERENCES o_bs_identity (id);

ALTER TABLE o_lecture_participant_summary ADD CONSTRAINT lec_part_entry_idx FOREIGN KEY (fk_entry) REFERENCES o_repositoryentry (repositoryentry_id);
ALTER TABLE o_lecture_participant_summary ADD CONSTRAINT lec_part_ident_idx FOREIGN KEY (fk_identity) REFERENCES o_bs_identity (id);

ALTER TABLE o_lecture_entry_config ADD CONSTRAINT lec_entry_config_entry_idx FOREIGN KEY (fk_entry) REFERENCES o_repositoryentry (repositoryentry_id);

CREATE INDEX idx_lec_audit_entry_idx ON o_lecture_block_audit_log (fk_entry);
CREATE INDEX idx_lec_audit_ident_idx ON o_lecture_block_audit_log (fk_identity);

ALTER TABLE o_lecture_block_to_tax_level ADD CONSTRAINT lblock_rel_to_lblock_idx FOREIGN KEY (fk_lecture_block) REFERENCES o_lecture_block (id);
ALTER TABLE o_lecture_block_to_tax_level ADD CONSTRAINT lblock_rel_to_tax_lev_idx FOREIGN KEY (fk_taxonomy_level) REFERENCES o_tax_taxonomy_level (id);

-- Taxonomy
ALTER TABLE o_tax_taxonomy ADD CONSTRAINT tax_to_group_idx FOREIGN KEY (fk_group) REFERENCES o_bs_group (id);

ALTER TABLE o_tax_taxonomy_level_type ADD CONSTRAINT tax_type_to_taxonomy_idx FOREIGN KEY (fk_taxonomy) REFERENCES o_tax_taxonomy (id);

ALTER TABLE o_tax_taxonomy_type_to_type ADD CONSTRAINT tax_type_to_type_idx FOREIGN KEY (fk_type) REFERENCES o_tax_taxonomy_level_type (id);
CREATE INDEX idx_tax_type_to_type_idx ON o_tax_taxonomy_type_to_type (fk_type);
ALTER TABLE o_tax_taxonomy_type_to_type ADD CONSTRAINT tax_type_to_sub_type_idx FOREIGN KEY (fk_allowed_sub_type) REFERENCES o_tax_taxonomy_level_type (id);
CREATE INDEX idx_tax_type_to_sub_type_idx ON o_tax_taxonomy_type_to_type (fk_allowed_sub_type);

ALTER TABLE o_tax_taxonomy_level ADD CONSTRAINT tax_level_to_taxonomy_idx FOREIGN KEY (fk_taxonomy) REFERENCES o_tax_taxonomy (id);
ALTER TABLE o_tax_taxonomy_level ADD CONSTRAINT tax_level_to_tax_level_idx FOREIGN KEY (fk_parent) REFERENCES o_tax_taxonomy_level (id);
ALTER TABLE o_tax_taxonomy_level ADD CONSTRAINT tax_level_to_type_idx FOREIGN KEY (fk_type) REFERENCES o_tax_taxonomy_level_type (id);
CREATE INDEX idx_tax_level_path_key_idx ON o_tax_taxonomy_level (t_m_path_keys);

ALTER TABLE o_tax_taxonomy_competence ADD CONSTRAINT tax_comp_to_tax_level_idx FOREIGN KEY (fk_level) REFERENCES o_tax_taxonomy_level (id);
ALTER TABLE o_tax_taxonomy_competence ADD CONSTRAINT tax_level_to_ident_idx FOREIGN KEY (fk_identity) REFERENCES o_bs_identity (id);

-- Dialog elements
ALTER TABLE o_dialog_element ADD CONSTRAINT dial_el_author_idx FOREIGN KEY (fk_author) REFERENCES o_bs_identity (id);
ALTER TABLE o_dialog_element ADD CONSTRAINT dial_el_entry_idx FOREIGN KEY (fk_entry) REFERENCES o_repositoryentry (repositoryentry_id);
ALTER TABLE o_dialog_element ADD CONSTRAINT dial_el_forum_idx FOREIGN KEY (fk_forum) REFERENCES o_forum (forum_id);
CREATE INDEX idx_dial_el_subident_idx ON o_dialog_element (d_subident);

-- Licenses
ALTER TABLE o_lic_license_type_activation ADD CONSTRAINT lic_activation_type_fk FOREIGN KEY (fk_license_type_id) REFERENCES o_lic_license_type (id);
CREATE INDEX lic_activation_type_idx ON o_lic_license_type_activation (fk_license_type_id);
ALTER TABLE o_lic_license ADD CONSTRAINT lic_license_type_fk FOREIGN KEY (fk_license_type_id) REFERENCES o_lic_license_type (id);
CREATE INDEX lic_license_type_idx ON o_lic_license (fk_license_type_id);
CREATE UNIQUE INDEX lic_license_ores_idx ON o_lic_license (l_resid, l_resname);

-- Organisation
ALTER TABLE o_org_organisation ADD CONSTRAINT org_to_group_idx FOREIGN KEY (fk_group) REFERENCES o_bs_group (id);
ALTER TABLE o_org_organisation ADD CONSTRAINT org_to_root_org_idx FOREIGN KEY (fk_root) REFERENCES o_org_organisation (id);
ALTER TABLE o_org_organisation ADD CONSTRAINT org_to_parent_org_idx FOREIGN KEY (fk_parent) REFERENCES o_org_organisation (id);
ALTER TABLE o_org_organisation ADD CONSTRAINT org_to_org_type_idx FOREIGN KEY (fk_type) REFERENCES o_org_organisation_type (id);

ALTER TABLE o_org_type_to_type ADD CONSTRAINT org_type_to_type_idx FOREIGN KEY (fk_type) REFERENCES o_org_organisation_type (id);
ALTER TABLE o_org_type_to_type ADD CONSTRAINT org_type_to_sub_type_idx FOREIGN KEY (fk_allowed_sub_type) REFERENCES o_org_organisation_type (id);

ALTER TABLE o_re_to_organisation ADD CONSTRAINT rel_org_to_re_idx FOREIGN KEY (fk_entry) REFERENCES o_repositoryentry (repositoryentry_id);
ALTER TABLE o_re_to_organisation ADD CONSTRAINT rel_org_to_org_idx FOREIGN KEY (fk_organisation) REFERENCES o_org_organisation (id);

-- Curriculum
ALTER TABLE o_cur_curriculum ADD CONSTRAINT cur_to_group_idx FOREIGN KEY (fk_group) REFERENCES o_bs_group (id);
ALTER TABLE o_cur_curriculum ADD CONSTRAINT cur_to_org_idx FOREIGN KEY (fk_organisation) REFERENCES o_org_organisation (id);

ALTER TABLE o_cur_curriculum_element ADD CONSTRAINT cur_el_to_group_idx FOREIGN KEY (fk_group) REFERENCES o_bs_group (id);
ALTER TABLE o_cur_curriculum_element ADD CONSTRAINT cur_el_to_cur_el_idx FOREIGN KEY (fk_parent) REFERENCES o_cur_curriculum_element (id);
ALTER TABLE o_cur_curriculum_element ADD CONSTRAINT cur_el_to_cur_idx FOREIGN KEY (fk_curriculum) REFERENCES o_cur_curriculum (id);
ALTER TABLE o_cur_curriculum_element ADD CONSTRAINT cur_el_type_to_el_type_idx FOREIGN KEY (fk_type) REFERENCES o_cur_element_type (id);

ALTER TABLE o_cur_element_type_to_type ADD CONSTRAINT cur_type_to_type_idx FOREIGN KEY (fk_type) REFERENCES o_cur_element_type (id);
ALTER TABLE o_cur_element_type_to_type ADD CONSTRAINT cur_type_to_sub_type_idx FOREIGN KEY (fk_allowed_sub_type) REFERENCES o_cur_element_type (id);

ALTER TABLE o_cur_element_to_tax_level ADD CONSTRAINT cur_el_rel_to_cur_el_idx FOREIGN KEY (fk_cur_element) REFERENCES o_cur_curriculum_element (id);
ALTER TABLE o_cur_element_to_tax_level ADD CONSTRAINT cur_el_to_tax_level_idx FOREIGN KEY (fk_taxonomy_level) REFERENCES o_tax_taxonomy_level (id);

-- Edu-sharing
CREATE INDEX idx_es_usage_ident_idx ON o_es_usage (e_identifier);
CREATE INDEX idx_es_usage_ores_idx ON o_es_usage (e_resid, e_resname);

-- Logging table
CREATE INDEX log_target_resid_idx ON o_loggingtable (targetresid);
CREATE INDEX log_ptarget_resid_idx ON o_loggingtable (parentresid);
CREATE INDEX log_gptarget_resid_idx ON o_loggingtable (grandparentresid);
CREATE INDEX log_ggptarget_resid_idx ON o_loggingtable (greatgrandparentresid);
CREATE INDEX log_creationdate_idx ON o_loggingtable (creationdate);

-- Livestream
CREATE INDEX idx_livestream_viewers_idx ON o_livestream_launch (l_subident, l_launch_date, fk_entry, fk_identity);

-- Grading
ALTER TABLE o_grad_to_identity ADD CONSTRAINT grad_to_ident_idx FOREIGN KEY (fk_identity) REFERENCES o_bs_identity (id);
ALTER TABLE o_grad_to_identity ADD CONSTRAINT grad_id_to_repo_idx FOREIGN KEY (fk_entry) REFERENCES o_repositoryentry (repositoryentry_id);

ALTER TABLE o_grad_assignment ADD CONSTRAINT grad_assign_to_entry_idx FOREIGN KEY (fk_reference_entry) REFERENCES o_repositoryentry (repositoryentry_id);
ALTER TABLE o_grad_assignment ADD CONSTRAINT grad_assign_to_assess_idx FOREIGN KEY (fk_assessment_entry) REFERENCES o_as_entry (id);
ALTER TABLE o_grad_assignment ADD CONSTRAINT grad_assign_to_grader_idx FOREIGN KEY (fk_grader) REFERENCES o_grad_to_identity (id);

ALTER TABLE o_grad_time_record ADD CONSTRAINT grad_time_to_assign_idx FOREIGN KEY (fk_assignment) REFERENCES o_grad_assignment (id);
ALTER TABLE o_grad_time_record ADD CONSTRAINT grad_time_to_grader_idx FOREIGN KEY (fk_grader) REFERENCES o_grad_to_identity (id);

ALTER TABLE o_grad_configuration ADD CONSTRAINT grad_config_to_entry_idx FOREIGN KEY (fk_entry) REFERENCES o_repositoryentry (repositoryentry_id);

-- Course
ALTER TABLE o_course_element ADD CONSTRAINT courseele_to_entry_idx FOREIGN KEY (fk_entry) REFERENCES o_repositoryentry (repositoryentry_id);
CREATE UNIQUE INDEX idx_courseele_subident_idx ON o_course_element (c_subident, fk_entry);

-- Course styles
CREATE UNIQUE INDEX idx_course_colcat_ident ON o_course_color_category (c_identifier);

-- Appointments
ALTER TABLE o_ap_topic ADD CONSTRAINT ap_topic_entry_idx FOREIGN KEY (fk_entry_id) REFERENCES o_repositoryentry (repositoryentry_id);
ALTER TABLE o_ap_organizer ADD CONSTRAINT ap_organizer_topic_idx FOREIGN KEY (fk_topic_id) REFERENCES o_ap_topic (id);
ALTER TABLE o_ap_organizer ADD CONSTRAINT ap_organizer_identity_idx FOREIGN KEY (fk_identity_id) REFERENCES o_bs_identity (id);
ALTER TABLE o_ap_topic_to_group ADD CONSTRAINT ap_tg_topic_idx FOREIGN KEY (fk_topic_id) REFERENCES o_ap_topic (id);
CREATE INDEX idx_ap_tg_group_idx ON o_ap_topic_to_group(fk_group_id);
ALTER TABLE o_ap_appointment ADD CONSTRAINT ap_appointment_topic_idx FOREIGN KEY (fk_topic_id) REFERENCES o_ap_topic (id);
ALTER TABLE o_ap_appointment ADD CONSTRAINT ap_appointment_meeting_idx FOREIGN KEY (fk_meeting_id) REFERENCES o_bbb_meeting (id);
ALTER TABLE o_ap_appointment ADD CONSTRAINT ap_appointment_teams_idx FOREIGN KEY (fk_teams_id) REFERENCES o_teams_meeting (id);
ALTER TABLE o_ap_participation ADD CONSTRAINT ap_part_appointment_idx FOREIGN KEY (fk_appointment_id) REFERENCES o_ap_appointment (id);
ALTER TABLE o_ap_participation ADD CONSTRAINT ap_part_identity_idx FOREIGN KEY (fk_identity_id) REFERENCES o_bs_identity (id);

-- Organization role rights
ALTER TABLE o_org_role_to_right ADD CONSTRAINT org_role_to_right_to_organisation_idx FOREIGN KEY (fk_organisation) REFERENCES o_org_organisation (id);
CREATE INDEX idx_org_role_to_right_to_organisation_idx ON o_org_role_to_right (fk_organisation);

-- Contact tracing
ALTER TABLE o_ct_registration ADD CONSTRAINT reg_to_loc_idx FOREIGN KEY (fk_location) REFERENCES o_ct_location (id);
CREATE INDEX idx_reg_to_loc_idx ON o_ct_registration (fk_location);
CREATE INDEX idx_qr_id_idx ON o_ct_location (l_qr_id);

-- Immunity proof
ALTER TABLE o_immunity_proof ADD CONSTRAINT proof_to_user_idx FOREIGN KEY (fk_user) REFERENCES o_bs_identity(id);
CREATE INDEX idx_immunity_proof ON o_immunity_proof (fk_user);

-- Zoom
ALTER TABLE o_zoom_profile ADD CONSTRAINT zoom_profile_tool_idx FOREIGN KEY (fk_lti_tool_id) REFERENCES o_lti_tool (id);
CREATE INDEX idx_zoom_profile_tool_idx ON o_zoom_profile (fk_lti_tool_id);

ALTER TABLE o_zoom_config ADD CONSTRAINT zoom_config_profile_idx FOREIGN KEY (fk_profile) REFERENCES o_zoom_profile (id);
CREATE INDEX idx_zoom_config_profile_idx ON o_zoom_config (fk_profile);

ALTER TABLE o_zoom_config ADD CONSTRAINT zoom_config_tool_deployment_idx FOREIGN KEY (fk_lti_tool_deployment_id) REFERENCES o_lti_tool_deployment (id);
CREATE INDEX idx_zoom_config_tool_deployment_idx ON o_zoom_config (fk_lti_tool_deployment_id);

ALTER TABLE o_zoom_config ADD CONSTRAINT zoom_config_context_idx FOREIGN KEY (fk_lti_context_id) REFERENCES o_lti_context (id);

-- Projects
ALTER TABLE o_proj_project ADD CONSTRAINT project_creator_idx FOREIGN KEY (fk_creator) REFERENCES o_bs_identity(id);
ALTER TABLE o_proj_project ADD CONSTRAINT project_group_idx FOREIGN KEY (fk_group) REFERENCES o_bs_group (id);
ALTER TABLE o_proj_project_to_org ADD CONSTRAINT rel_pto_project_idx FOREIGN KEY (fk_project) REFERENCES o_proj_project (id);
ALTER TABLE o_proj_project_to_org ADD CONSTRAINT rel_pto_org_idx FOREIGN KEY (fk_organisation) REFERENCES o_org_organisation (id);
ALTER TABLE o_proj_template_to_org ADD CONSTRAINT rel_tto_project_idx FOREIGN KEY (fk_project) REFERENCES o_proj_project (id);
ALTER TABLE o_proj_template_to_org ADD CONSTRAINT rel_tto_org_idx FOREIGN KEY (fk_organisation) REFERENCES o_org_organisation (id);
ALTER TABLE o_proj_project_user_info ADD CONSTRAINT rel_pui_project_idx FOREIGN KEY (fk_project) REFERENCES o_proj_project (id);
ALTER TABLE o_proj_project_user_info ADD CONSTRAINT rel_pui_identity_idx FOREIGN KEY (fk_identity) REFERENCES o_bs_identity(id);

ALTER TABLE o_proj_artefact ADD CONSTRAINT artefact_modby_idx FOREIGN KEY (fk_content_modified_by) REFERENCES o_bs_identity(id);
ALTER TABLE o_proj_artefact ADD CONSTRAINT artefact_project_idx FOREIGN KEY (fk_project) REFERENCES o_proj_project (id);
ALTER TABLE o_proj_artefact ADD CONSTRAINT artefact_creator_idx FOREIGN KEY (fk_creator) REFERENCES o_bs_identity(id);
ALTER TABLE o_proj_artefact ADD CONSTRAINT artefact_group_idx FOREIGN KEY (fk_group) REFERENCES o_bs_group (id);
ALTER TABLE o_proj_artefact_to_artefact ADD CONSTRAINT projata_artefact1_idx FOREIGN KEY (fk_artefact1) REFERENCES o_proj_artefact (id);
ALTER TABLE o_proj_artefact_to_artefact ADD CONSTRAINT projata_artefact2_idx FOREIGN KEY (fk_artefact2) REFERENCES o_proj_artefact (id);
ALTER TABLE o_proj_artefact_to_artefact ADD CONSTRAINT projata_project_idx FOREIGN KEY (fk_project) REFERENCES o_proj_project (id);
ALTER TABLE o_proj_artefact_to_artefact ADD CONSTRAINT projata_creator_idx FOREIGN KEY (fk_creator) REFERENCES o_bs_identity(id);

ALTER TABLE o_proj_tag ADD CONSTRAINT tag_project_idx FOREIGN KEY (fk_project) REFERENCES o_proj_project (id);
ALTER TABLE o_proj_tag ADD CONSTRAINT tag_artefact_idx FOREIGN KEY (fk_artefact) REFERENCES o_proj_artefact (id);
ALTER TABLE o_proj_tag ADD CONSTRAINT tag_tag_idx FOREIGN KEY (fk_tag) REFERENCES o_tag_tag (id);

ALTER TABLE o_proj_file ADD CONSTRAINT file_artefact_idx FOREIGN KEY (fk_artefact) REFERENCES o_proj_artefact (id);
ALTER TABLE o_proj_file ADD CONSTRAINT file_metadata_idx FOREIGN KEY (fk_metadata) REFERENCES o_vfs_metadata(id);
ALTER TABLE o_proj_todo ADD CONSTRAINT todo_artefact_idx FOREIGN KEY (fk_artefact) REFERENCES o_proj_artefact (id);
ALTER TABLE o_proj_todo ADD CONSTRAINT todo_todo_idx FOREIGN KEY (fk_todo_task) REFERENCES o_todo_task(id);
CREATE UNIQUE INDEX idx_todo_ident_idx ON o_proj_todo (p_identifier);
ALTER TABLE o_proj_note ADD CONSTRAINT note_artefact_idx FOREIGN KEY (fk_artefact) REFERENCES o_proj_artefact (id);
ALTER TABLE o_proj_appointment ADD CONSTRAINT appointment_artefact_idx FOREIGN KEY (fk_artefact) REFERENCES o_proj_artefact (id);
CREATE UNIQUE INDEX idx_appointment_ident_idx ON o_proj_appointment (p_identifier);
ALTER TABLE o_proj_milestone ADD CONSTRAINT milestone_artefact_idx FOREIGN KEY (fk_artefact) REFERENCES o_proj_artefact (id);
CREATE UNIQUE INDEX idx_milestone_ident_idx ON o_proj_milestone (p_identifier);
ALTER TABLE o_proj_decision ADD CONSTRAINT decision_artefact_idx FOREIGN KEY (fk_artefact) REFERENCES o_proj_artefact (id);

ALTER TABLE o_proj_activity ADD CONSTRAINT activity_doer_idx FOREIGN KEY (fk_doer) REFERENCES o_bs_identity (id);
ALTER TABLE o_proj_activity ADD CONSTRAINT activity_project_idx FOREIGN KEY (fk_project) REFERENCES o_proj_project (id);
CREATE INDEX idx_activity_artefact_idx ON o_proj_activity (fk_artefact);
CREATE INDEX idx_activity_artefact_reference_idx ON o_proj_activity (fk_artefact_reference);
ALTER TABLE o_proj_activity ADD CONSTRAINT activity_member_idx FOREIGN KEY (fk_member) REFERENCES o_bs_identity (id);
ALTER TABLE o_proj_activity ADD CONSTRAINT activity_organisation_idx FOREIGN KEY (fk_organisation) REFERENCES o_org_organisation (id);
CREATE INDEX idx_activity_temp_ident_idx ON o_proj_activity (p_temp_identifier);

-- JupyterHub
ALTER TABLE o_jup_hub ADD CONSTRAINT jup_hub_tool_idx FOREIGN KEY (fk_lti_tool_id) REFERENCES o_lti_tool (id);
CREATE INDEX idx_jup_hub_tool_idx ON o_jup_hub (fk_lti_tool_id);

ALTER TABLE o_jup_deployment ADD CONSTRAINT jup_deployment_hub_idx FOREIGN KEY (fk_hub) REFERENCES o_jup_hub (id);
CREATE INDEX idx_jup_deployment_hub_idx ON o_jup_deployment (fk_hub);

ALTER TABLE o_jup_deployment ADD CONSTRAINT jup_deployment_tool_deployment_idx FOREIGN KEY (fk_lti_tool_deployment_id) REFERENCES o_lti_tool_deployment (id);
CREATE INDEX idx_jup_deployment_tool_deployment_idx ON o_jup_deployment (fk_lti_tool_deployment_id);

ALTER TABLE o_jup_deployment ADD CONSTRAINT jup_deployment_context_idx FOREIGN KEY (fk_lti_context_id) REFERENCES o_lti_context (id);

-- Open Badges
CREATE INDEX o_badge_class_uuid_idx ON o_badge_class (b_uuid);
CREATE INDEX o_badge_assertion_uuid_idx ON o_badge_assertion (b_uuid);

ALTER TABLE o_badge_class ADD CONSTRAINT badge_class_entry_idx FOREIGN KEY (fk_entry) REFERENCES o_repositoryentry (repositoryentry_id);

ALTER TABLE o_badge_assertion ADD CONSTRAINT badge_assertion_class_idx FOREIGN KEY (fk_badge_class) REFERENCES o_badge_class (id);

ALTER TABLE o_badge_assertion ADD CONSTRAINT badge_assertion_recipient_idx FOREIGN KEY (fk_recipient) REFERENCES o_bs_identity (id);

ALTER TABLE o_badge_assertion ADD CONSTRAINT badge_assertion_awarded_by_idx FOREIGN KEY (fk_awarded_by) REFERENCES o_bs_identity (id);

ALTER TABLE o_badge_category ADD CONSTRAINT badge_category_tag_idx FOREIGN KEY (fk_tag) REFERENCES o_tag_tag (id);

ALTER TABLE o_badge_category ADD CONSTRAINT badge_category_template_idx FOREIGN KEY (fk_template) REFERENCES o_badge_template (id);

ALTER TABLE o_badge_category ADD CONSTRAINT badge_category_class_idx FOREIGN KEY (fk_class) REFERENCES o_badge_class (id);

ALTER TABLE o_badge_entry_config ADD CONSTRAINT badge_entry_config_entry_idx FOREIGN KEY (fk_entry) REFERENCES o_repositoryentry (repositoryentry_id);

-- Gui Preferences
ALTER TABLE o_gui_prefs ADD CONSTRAINT o_gui_prefs_identity_idx FOREIGN KEY (fk_identity) REFERENCES o_bs_identity (id);
CREATE INDEX idx_o_gui_prefs_attrclass_idx ON o_gui_prefs (g_pref_attributed_class);
CREATE INDEX idx_o_gui_prefs_key_idx ON o_gui_prefs (g_pref_key);

-- Hibernate Unique Key
INSERT INTO hibernate_unique_key (next_hi) VALUES (0);
