
echo Running create_syn_syns_master.sql
sqlplus $1/$2 @./METADATA/MASTER_SITE/create_syn_syns_master.sql $HDB_LOCAL $HDB_LOCAL > create_syn_syns_master.out
grep ERROR create_syn_syns_master.out

echo Running pop_pk_syns.ddl
sqlplus $1/$2 @./METADATA/pop_pk_syns.ddl $HDB_LOCAL $HDB_LOCAL $HDB_LOCAL > pop_pk_syns.ddl.out
grep ERROR pop_pk_syns.ddl.out

echo Running gen_trigs.sql
sqlplus $1/$2 @./METADATA/MASTER_SITE/gen_trigs.sql > gen_trigs.out
grep ERROR gen_trigs.out

# removed by M. Bogner, SUtron Corporation 30-JUNE-2011
# couldn't figure out why/what it is and looks like it is not needed for normal island installation
#echo Running get_pk_val_wrap.sql
#sqlplus $1/$2 < ./METADATA/get_pk_val_wrap.sql > get_pk_val_wrap.out
#grep ERROR get_pk_val_wrap.out

echo Running cg_ref_codes.ddl
sqlplus $1/$2 < ./METADATA/cg_ref_codes.ddl > cg_ref_codes.out
grep ERROR cg_ref_codes.out

echo Running V_DT_UT.sql
sqlplus $1/$2 < ./METADATA/V_DT_UT.sql > V_DT_UT.out
grep ERROR V_DT_UT.out

echo Running V_SITEDT.sql
sqlplus $1/$2 < ./METADATA/V_SITEDT.sql > V_SITEDT.out
grep ERROR V_SITEDT.out

echo Running V_DBA_ROLES.sql
sqlplus $1/$2 < ./METADATA/V_DBA_ROLES.sql > V_DBA_ROLES.out
grep ERROR V_DBA_ROLES.out

echo Running ../../ref_installation.ddl
sqlplus $1/$2  @./METADATA/ref_installation.ddl island > ref_installation.out
grep ERROR ref_installation.out

#echo "** Island installation created. ** Press Enter to continue..."
#read prompt
#exit


