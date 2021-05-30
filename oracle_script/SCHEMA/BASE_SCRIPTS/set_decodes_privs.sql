set echo on
set feedback on

spool set_decodes_privs.out

create public synonym CONFIGSENSOR for decodes.CONFIGSENSOR;                                                            
create public synonym CONFIGSENSORDATATYPE for decodes.CONFIGSENSORDATATYPE;                                            
create public synonym CONFIGSENSORPROPERTY for decodes.CONFIGSENSORPROPERTY;                                            
create public synonym DECODESDATABASEVERSION for decodes.DECODESDATABASEVERSION;
create public synonym DATAPRESENTATION for decodes.DATAPRESENTATION;                                                    
create public synonym DATASOURCE for decodes.DATASOURCE;                                                                
create public synonym DATASOURCEGROUPMEMBER for decodes.DATASOURCEGROUPMEMBER;                                          
create public synonym DATATYPE for decodes.DATATYPE;

create public synonym DATATYPEEQUIVALENCE for decodes.DATATYPEEQUIVALENCE;                                              
create public synonym DECODESSCRIPT for decodes.DECODESSCRIPT;                                                          
create public synonym ENUM for decodes.ENUM;                                                                            
create public synonym ENUMVALUE for decodes.ENUMVALUE;                                                                  
create public synonym EQUIPMENTMODEL for decodes.EQUIPMENTMODEL;                                                        
create public synonym EQUIPMENTPROPERTY for decodes.EQUIPMENTPROPERTY;                                                  
create public synonym FORMATSTATEMENT for decodes.FORMATSTATEMENT;                                                      
create public synonym NETWORKLIST for decodes.NETWORKLIST;                                                              
create public synonym NETWORKLISTENTRY for decodes.NETWORKLISTENTRY;                                                    
create public synonym PLATFORM for decodes.PLATFORM;                                                                    
create public synonym PLATFORMCONFIG for decodes.PLATFORMCONFIG;                                                        
create public synonym PLATFORMPROPERTY for decodes.PLATFORMPROPERTY;                                                    
create public synonym PLATFORMSENSOR for decodes.PLATFORMSENSOR;                                                        
create public synonym PLATFORMSENSORPROPERTY for decodes.PLATFORMSENSORPROPERTY;                                        
create public synonym PRESENTATIONGROUP for decodes.PRESENTATIONGROUP;                                                  
create public synonym ROUNDINGRULE for decodes.ROUNDINGRULE;                                                            
create public synonym ROUTINGSPEC for decodes.ROUTINGSPEC;                                                              
create public synonym ROUTINGSPECNETWORKLIST for decodes.ROUTINGSPECNETWORKLIST;                                        
create public synonym ROUTINGSPECPROPERTY for decodes.ROUTINGSPECPROPERTY;                                              
create public synonym SCRIPTSENSOR for decodes.SCRIPTSENSOR;                                                            
create public synonym TRANSPORTMEDIUM for decodes.TRANSPORTMEDIUM;                                                      
create public synonym UNITCONVERTER for decodes.UNITCONVERTER;                                                          
grant select on decodes.CONFIGSENSOR to public;                                                                         
grant select on decodes.CONFIGSENSORDATATYPE to public;                                                                 
grant select on decodes.CONFIGSENSORPROPERTY to public;                                                                 
grant select on decodes.DECODESDATABASEVERSION to public;                                                                      
grant select on decodes.DATAPRESENTATION to public;                                                                     
grant select on decodes.DATAPRESENTATIONIDSEQ to decodes_role;                                                          
grant select on decodes.DATASOURCE to public;                                                                           
grant select on decodes.DATASOURCEGROUPMEMBER to public;                                                                
grant select on decodes.DATASOURCEIDSEQ to decodes_role;                                                                
grant select on decodes.DATATYPE to public;                                                                  

grant select on decodes.DATATYPEIdSeq to public;                                                                  

grant select on decodes.DATATYPEEQUIVALENCE to public;                                                                  
grant select on decodes.DECODESSCRIPT to public;                                                                        
grant select on decodes.DECODESSCRIPTIDSEQ to decodes_role;                                                             
grant select on decodes.ENUM to public;                                                                                 
grant select on decodes.ENUMIDSEQ to decodes_role;                                                                      
grant select on decodes.ENUMVALUE to public;                                                                            
grant select on decodes.EQUIPMENTIDSEQ to decodes_role;                                                                 
grant select on decodes.EQUIPMENTMODEL to public;                                                                       
grant select on decodes.EQUIPMENTPROPERTY to public;                                                                    
grant select on decodes.FORMATSTATEMENT to public;                                                                      
grant select on decodes.NETWORKLIST to public;                                                                          
grant select on decodes.NETWORKLISTENTRY to public;                                                                     
grant select on decodes.NETWORKLISTIDSEQ to decodes_role;                                                               
grant select on decodes.PLATFORM to public;                                                                             
grant select on decodes.PLATFORMCONFIG to public;                                                                       
grant select on decodes.PLATFORMCONFIGIDSEQ to decodes_role;                                                            
grant select on decodes.PLATFORMIDSEQ to decodes_role;                                                                  
grant select on decodes.PLATFORMPROPERTY to public;                                                                     
grant select on decodes.PLATFORMSENSOR to public;                                                                       
grant select on decodes.PLATFORMSENSORPROPERTY to public;                                                               
grant select on decodes.PRESENTATIONGROUP to public;                                                                    
grant select on decodes.PRESENTATIONGROUPIDSEQ to decodes_role;                                                         
grant select on decodes.ROUNDINGRULE to public;                                                                         
grant select on decodes.ROUTINGSPEC to public;                                                                          
grant select on decodes.ROUTINGSPECIDSEQ to decodes_role;                                                               
grant select on decodes.ROUTINGSPECNETWORKLIST to public;                                                               
grant select on decodes.ROUTINGSPECPROPERTY to public;                                                                  
grant select on decodes.SCRIPTSENSOR to public;                                                                         
grant select on decodes.TRANSPORTMEDIUM to public;                                                                      
grant select on decodes.UNITCONVERTER to public;                                                                        
grant select on decodes.UNITCONVERTERIDSEQ to decodes_role;                                                             
grant select, insert, update, delete on decodes.CONFIGSENSOR to decodes_role;
grant select, insert, update, delete on decodes.CONFIGSENSORDATATYPE to decodes_role;
grant select, insert, update, delete on decodes.CONFIGSENSORPROPERTY to decodes_role;
grant select, insert, update, delete on decodes.DECODESDATABASEVERSION to decodes_role;
grant select, insert, update, delete on decodes.DATAPRESENTATION to decodes_role;
grant select, insert, update, delete on decodes.DATASOURCE to decodes_role;
grant select, insert, update, delete on decodes.DATASOURCEGROUPMEMBER to decodes_role;
grant select, insert, update, delete on decodes.DATATYPE to decodes_role;
grant select, insert, update, delete on decodes.DATATYPEEQUIVALENCE to decodes_role;
grant select, insert, update, delete on decodes.DECODESSCRIPT to decodes_role;
grant select, insert, update, delete on decodes.ENUM to decodes_role;
grant select, insert, update, delete on decodes.ENUMVALUE to decodes_role;
grant select, insert, update, delete on decodes.EQUIPMENTMODEL to decodes_role;
grant select, insert, update, delete on decodes.EQUIPMENTPROPERTY to decodes_role;
grant select, insert, update, delete on decodes.FORMATSTATEMENT to decodes_role;
grant select, insert, update, delete on decodes.NETWORKLIST to decodes_role;
grant select, insert, update, delete on decodes.NETWORKLISTENTRY to decodes_role;
grant select, insert, update, delete on decodes.PLATFORM to decodes_role;
grant select, insert, update, delete on decodes.PLATFORMCONFIG to decodes_role;
grant select, insert, update, delete on decodes.PLATFORMPROPERTY to decodes_role;
grant select, insert, update, delete on decodes.PLATFORMSENSOR to decodes_role;
grant select, insert, update, delete on decodes.PLATFORMSENSORPROPERTY to decodes_role;
grant select, insert, update, delete on decodes.PRESENTATIONGROUP to decodes_role;
grant select, insert, update, delete on decodes.ROUNDINGRULE to decodes_role;
grant select, insert, update, delete on decodes.ROUTINGSPEC to decodes_role;
grant select, insert, update, delete on decodes.ROUTINGSPECNETWORKLIST to decodes_role;
grant select, insert, update, delete on decodes.ROUTINGSPECPROPERTY to decodes_role;
grant select, insert, update, delete on decodes.SCRIPTSENSOR to decodes_role;
grant select, insert, update, delete on decodes.TRANSPORTMEDIUM to decodes_role;
grant select, insert, update, delete on decodes.UNITCONVERTER to decodes_role;

grant select, insert, update, delete on decodes.ENUM to DBA with grant option;
grant select, insert, update, delete on decodes.ENUMVALUE to DBA with grant option;

spool off
exit;

