/*************************************************************************************************************
 *  Function:  retrieve and parse data from SCADA via a serial connection between SUN and SCADA
 *
 *  Author:    Brad Vickers
 *
 *  Date:      December 1, 1992, revised January 31, 1994, revised for Solaris 2.3 September 1994
 *
 *  Purpose:   1. recieve and parse reservoir parameters from the Colorado River SCADA system
 *             2. submit daily data to hydromet for processing daily report
 *             3. submit hourly data for Glen Canyon to Flagstaff Office
 *             4. submit daily data to the River Forcast Center
 *
 **************************************************************************************************************/



#include <math.h>
#include <stdio.h>
#include <string.h>
#include <sys/types.h>
#include <sys/uio.h>
#include <unistd.h>
#include <fcntl.h>
#include <stropts.h>
#include <poll.h>
#include <errno.h>
#include <sys/termios.h>
#include <ctype.h>

#define SIZE 40
#define HYDRO "hydromet_\0"
#define CRSP "crsp_\0"
#define GLEN  "glen_\0"



main()
{
	char   buf[132], buffer[BUFSIZ], resname1[14], resname2[14], resname3[14], resname4[14];
        char   resname5[14], resname6[14], date[30],dum[41],dum1[41],dum2[41],dum3[41],dum4[41],dum5[41];
        char   dum6[41], output[40], outputt[40], outputtt[40], DATE[30];
        char   *orgin = HYDRO;
        char   *orgin1 = CRSP;
        char   *orgin2 = GLEN;
        char   hydro[SIZE], crsp[SIZE], glen[SIZE];
        char   mon[3];
        char   day[3];
        char    yr[3];

        struct pollfd pollfds[1];
	struct strbuf *dataptr;
        struct termios *arg;

	int    fid, i, j, m, k, num_res, num_row, num_col, str_cursor, cur_baud, cur_size, cur_cread, cur_odd, cur_cr;
        int    cur_hupcl, cur_clocal, cur_crtscts, cur_parenb, cur_cstopb, cur_cibaud, cur_echo;
        int    hour[24][6];

	float  elev[24][6], tail[24][6], head[24][6], gen[24][6], pow_rel[24][6], spill[24][6], bypass[24][6], riv[24][6];
        float  telev[6],ttail[6],thead[6],tgen[6],tpow_rel[6],tspill[6],tbypass[6],triv[6];
        float  aelev[6],atail[6],ahead[6],agen[6],apow_rel[6],aspill[6],abypass[6],ariv[6];
        float  pow_relaf[6],spillaf[6],bypassaf[6],rivaf[6],bypassaf1[6];

	FILE   *fd, *out, *outt, *outtt, *out1, *out1_alpha, *out2, *out3, *out4, *out5;

	if ((fid = open("/dev/ttya", O_RDONLY)) < 0)
	{
	   perror("open serial port /dev/ttya for reading failed");
           exit (1);
     	}
        arg = (struct termios *)malloc(sizeof(struct termios));
        if (ioctl(fid, TCGETS, arg) > 0);
            {
            printf("\n\n\n%s\n\n", "ready to download SCADA data");
            }

        cur_baud = arg->c_cflag & CBAUD;
        cur_size = arg->c_cflag & CSIZE;
        cur_cstopb = arg->c_cflag & CSTOPB;
        cur_cread = arg->c_cflag & CREAD;
        cur_parenb = arg->c_cflag & PARENB;
        cur_odd = arg->c_cflag & PARODD;
        cur_hupcl = arg->c_cflag & HUPCL;
        cur_clocal = arg->c_cflag & CLOCAL;
        cur_cibaud = CBAUD << IBSHIFT;
        cur_crtscts = arg->c_cflag & CRTSCTS; 

/*	printf("curbaud= %i\n", cur_baud);
	printf("cursize= %i\n", cur_size);
	printf("curcstopb= %i\n", cur_cstopb);
	printf("curcread= %i\n", cur_cread);
	printf("curparenb= %i\n", cur_parenb);
	printf("curodd= %i\n", cur_odd);
	printf("curhubcl= %i\n", cur_hupcl);
	printf("curclocal= %i\n", cur_clocal);
	printf("curcibaud= %i\n", cur_cibaud);
	printf("curcrtscts= %i\n", cur_crtscts); */

        arg->c_cflag = arg->c_cflag - cur_baud + B2400;
        arg->c_cflag = arg->c_cflag - cur_size + CS7;
        arg->c_cflag = arg->c_cflag & ~CSTOPB;
        arg->c_cflag = arg->c_cflag | CREAD;
        arg->c_cflag = arg->c_cflag | PARENB;
        arg->c_cflag = arg->c_cflag | PARODD;
        arg->c_cflag = arg->c_cflag & ~HUPCL;
        arg->c_cflag = arg->c_cflag | CLOCAL;
        arg->c_cflag = arg->c_cflag & ~CRTSCTS;
        arg->c_lflag = arg->c_lflag & ~ECHO;
        arg->c_iflag = arg->c_iflag & ~ICRNL;
        arg->c_iflag = arg->c_iflag | IGNCR; 

/*        cur_baud = arg->c_cflag & CBAUD;
        cur_size = arg->c_cflag & CSIZE;
        cur_cstopb = arg->c_cflag & CSTOPB;
        cur_cread = arg->c_cflag & CREAD;
        cur_parenb = arg->c_cflag & PARENB;
        cur_odd = arg->c_cflag & PARODD;
        cur_hupcl = arg->c_cflag & HUPCL;
        cur_clocal = arg->c_cflag & CLOCAL;
        cur_cibaud = CBAUD << IBSHIFT;
        cur_crtscts = arg->c_cflag & CRTSCTS; 

	printf("curbaud= %i\n", cur_baud);
	printf("cursize= %i\n", cur_size);
	printf("curcstopb= %i\n", cur_cstopb);
	printf("curcread= %i\n", cur_cread);
	printf("curparenb= %i\n", cur_parenb);
	printf("curodd= %i\n", cur_odd);
	printf("curhubcl= %i\n", cur_hupcl);
	printf("curclocal= %i\n", cur_clocal);
	printf("curcibaud= %i\n", cur_cibaud);
	printf("curcrtscts= %i\n", cur_crtscts); */


        if (ioctl(fid, TCSETS, arg) > 0);
            {
            printf("%s\n", "");
            }

        cur_echo = arg->c_lflag & ECHO;
        cur_cr = arg->c_iflag & IGNCR;

        num_res = 1;
        num_col =1;

        j = 0;

        while (num_res  <= 6)
         {
            num_row = 1;
            while (num_row <=48)
            {
              
              if (num_row <= 5)
                {
               read(fid, buf, 132);
                num_row = num_row + 1;
                continue;
                }
              if (num_row == 6)
                {
                 read(fid, buf, 132);
                    switch (num_res)
                    {
                    case 1:
                           sscanf(buf, "%s%s%s%s%s%s%s",resname1,dum1,dum2,dum3,dum4,dum5,DATE);
                           printf("%s          %s\n", resname1, DATE);
                           break;

                    case 2:
                           sscanf(buf, "%s",resname2);
                           printf("%s          %s\n", resname2, DATE);
                           break;


                    case 3:
                           sscanf(buf, "%s",resname3);
                           printf("%s          %s\n", resname3, DATE);
                           break;


                    case 4:
                           sscanf(buf, "%s",resname4);
                           printf("%s          %s\n", resname4, DATE);
                           break;


                    case 5:
                           sscanf(buf, "%s",resname5);
                           printf("%s          %s\n", resname5, DATE);
                           break;


                    case 6:
                           sscanf(buf, "%s",resname6);
                           printf("%s          %s\n", resname6, DATE);
                           break;


                    default:
                           printf("%s\n", "Hit the default in the switch statement");
                           break;

                    } /* end of switch */

                 num_row = num_row + 1;
                }

              if (num_row >= 7 && num_row <= 9)
                 {
                read(fid, buf, 132);
                num_row = num_row + 1;
                continue;
                  }

              if (num_row >= 10 && num_row <= 33)
                {
                 read(fid, buf, 132);

                 i=num_row-10;
                 j=num_res-1;

                 sscanf(buf,"%5d%12f%10f%9f%7f%8f%9f%9f",&hour[i][j],
                        &elev[i][j],&tail[i][j],&head[i][j],
                        &gen[i][j],&pow_rel[i][j],&spill[i][j],
                        &bypass[i][j]);
                 printf("%5d  %12.2f  %10.2f  %9.2f  %7.0f  %8.0f  %9.0f  %9.0f\n",hour[i][j],elev[i][j],
                       tail[i][j],head[i][j],
                       gen[i][j],pow_rel[i][j],spill[i][j],
                       bypass[i][j]);

                 num_row = num_row + 1;
                 }
               if (num_row >= 34 && num_row <= 49)
                 {
                  read(fid, buf, 132);
                  num_row = num_row + 1;
                  continue;
                 }
                 } /* end of read while */
             num_res = num_res + 1;

             } /* end of first while */

             for (j=0; j<=5; j++)
             {
                for (i=0; i<=23; i++)
                {
                 riv[i][j] = pow_rel[i][j] + spill[i][j] + bypass[i][j];
                 }
              }


             for (j=0; j<=5; j++)
             {
                for (i=0; i<=23; i++)
                {
                  telev[j] = elev[i][j] + telev[j];
                  ttail[j] = tail[i][j] + ttail[j];
                  thead[j] = head[i][j] + thead[j];
                  tgen[j] = gen[i][j] + tgen[j];
                  tpow_rel[j] = pow_rel[i][j] + tpow_rel[j];
                  tspill[j] = spill[i][j] + tspill[j];
                  tbypass[j] = bypass[i][j] + tbypass[j];
                  triv[j] = riv[i][j] + triv[j];
                 }
              }

             for (j=0; j<=5; j++)
             {
                  aelev[j] =  telev[j]/24;
                  atail[j] =  ttail[j]/24;
                  ahead[j] =  thead[j]/24;
                  agen[j] =   tgen[j]/24;
                  apow_rel[j] = tpow_rel[j]/24;
                  aspill[j] =  tspill[j]/24;
                  abypass[j] = tbypass[j]/24;
                  ariv[j] =  triv[j]/24;
                 
              }

             for (j=0; j<=5; j++)
             {
                  pow_relaf[j] = apow_rel[j]*1.9835;
                  spillaf[j] =  aspill[j]*1.9835;
                  bypassaf[j] = abypass[j]*1.9835;
                  rivaf[j] =  ariv[j]*1.9835;
             }

     strncpy(&mon[0], &DATE[0], 2);
     mon[2]='\0';
/*
     printf("%s\n",&mon[0]);
*/
     strncpy(&day[0], &DATE[3], 2);
     day[2]= '\0';
/*
     printf("%s\n",&day[0]);
*/ 
     strncpy(&yr[0], &DATE[6], 2);
     yr[2]= '\0';
/*
     printf("%s\n",&yr[0]);
*/   

	date[0] = '\0';

     if (strcmp(&mon[0], "11") == 0)
        {
        strcat(&date[0],&yr[0]);
        strcat(&date[0],"NOV");  
        strcat(&date[0],&day[0]);
        }


     if (strcmp(&mon[0], "12") == 0)
        {
        strcat(&date[0],&yr[0]);
        strcat(&date[0],"DEC");  
        strcat(&date[0],&day[0]);
        }

     if (strcmp(&mon[0], "01") == 0)
        {
        strcat(&date[0],&yr[0]);
        strcat(&date[0],"JAN");  
        strcat(&date[0],&day[0]);
        }

     if (strcmp(&mon[0], "02") == 0)
        {
        strcat(&date[0],&yr[0]);
        strcat(&date[0],"FEB");  
        strcat(&date[0],&day[0]);
        }

     if (strcmp(&mon[0], "03") == 0)
        {
        strcat(&date[0],&yr[0]);
        strcat(&date[0],"MAR");  
        strcat(&date[0],&day[0]);
        }

     if (strcmp(&mon[0], "04") == 0)
        {
        strcat(&date[0],&yr[0]);
        strcat(&date[0],"APR");  
        strcat(&date[0],&day[0]);
        }

     if (strcmp(&mon[0], "05") == 0)
        {
        strcat(&date[0],&yr[0]);
        strcat(&date[0],"MAY");  
        strcat(&date[0],&day[0]);
        }

     if (strcmp(&mon[0], "06") == 0)
        {
        strcat(&date[0],&yr[0]);
        strcat(&date[0],"JUN");  
        strcat(&date[0],&day[0]);
        }

     if (strcmp(&mon[0], "07") == 0)
        {
        strcat(&date[0],&yr[0]);
        strcat(&date[0],"JUL");  
        strcat(&date[0],&day[0]);
        }

     if (strcmp(&mon[0], "08") == 0)
        {
        strcat(&date[0],&yr[0]);
        strcat(&date[0],"AUG");  
        strcat(&date[0],&day[0]);
        }

     if (strcmp(&mon[0], "09") == 0)
        {
        strcat(&date[0],&yr[0]);
        strcat(&date[0],"SEP");  
        strcat(&date[0],&day[0]);
        }

     if (strcmp(&mon[0], "10") == 0)
        {
        strcat(&date[0],&yr[0]);
        strcat(&date[0],"OCT");  
        strcat(&date[0],&day[0]);
        }

	hydro[0] = '\0';
	crsp[0] = '\0';
	glen[0] = '\0';

        strcat(&hydro[0],orgin);
        strcat(&hydro[0],&date[0]);
        strcat(&hydro[0],".dat");

        strcat(&crsp[0],orgin1);
        strcat(&crsp[0],&date[0]);
        strcat(&crsp[0],".dat");

        strcat(&glen[0],orgin2);
        strcat(&glen[0],&date[0]);
        strcat(&glen[0],".dat");
/*
        printf("%s\n", &hydro[0]);
        printf("%s\n", &crsp[0]);
        printf("%s\n", &glen[0]);
*/         
               
              if ((out1 = fopen("./crsp.script","w+")) == NULL)
                 {
                  fprintf(stderr, "can't open output for crsp.script\n");
                  exit(1);
                  }
              fprintf(out1,"%s\n","cd \"dub11:[dmsdata.crsp]\"");
              fprintf(out1,"%s %s\n","put",&hydro[0]);
              fprintf(out1,"%s\n","quit");

              fclose(out1);

/*  next file is for the alpha - added by tom ryan on 7/28/1999 */

              if ((out1_alpha = fopen("./crsp_alpha.script","w+")) == NULL)
                 {
                  fprintf(stderr, "can't open output for crsp_alpha.script\n");
                  exit(1);
                  }
              fprintf(out1_alpha,"%s\n","cd \"uc280:[hydromet.scada_files]\"");
              fprintf(out1_alpha,"%s %s\n","put",&hydro[0]);
              fprintf(out1_alpha,"%s\n","quit");

              fclose(out1_alpha);

              if ((out2 = fopen("./dum","w+")) == NULL)
                 {
                  fprintf(stderr, "can't open output for dum\n");
                  exit(1);
                  }
              fprintf(out2, "%s\n", &hydro[0]);

              fclose(out2);

		if ((out2 = fopen("./dum1","w+")) == NULL)
			{
			fprintf(stderr, "can't open output for dum1\n");
			exit(1);
			}
		fprintf(out2, "%s\n", &crsp[0]);
		fclose(out2);

               
              if ((out3 = fopen("./glen.script","w+")) == NULL)
                 {
                  fprintf(stderr, "can't open output for glen.script\n");
                  exit(1);
                  }
              fprintf(out3,"%s\n",&glen[0]);

              fclose(out3);

              if ((out4 = fopen("./rfc.script","w+")) == NULL)
                 {
                  fprintf(stderr, "can't open output for rfc.script\n");
                  exit(1);
                  }
              fprintf(out4,"%s\n","cd \"incoming>ftp\"");
              fprintf(out4,"%s %s\n","put","hydromet.dat");
              fprintf(out4,"%s\n","quit");

              fclose(out4);

              if ((out = fopen(&crsp[0],"w+")) == NULL)
                {
                 fprintf(stderr, "can't open output for writing\n");
                 exit(1);
                 }

              if ((outt = fopen(&hydro[0],"w+")) == NULL)
                {
                 fprintf(stderr, "can't open outputt for writing\n");
                 exit(1);
                 }

              if ((outtt = fopen(&glen[0],"w+")) == NULL)
                {
                 fprintf(stderr, "can't open outputtt for writing\n");
                 exit(1);
                 }   

               for( j=0; j <= 5; j++)
                 { 

                   if (j == 0)
                       {
                        fprintf(out, "\n%s            %s\n\n",resname1, date);
                        fprintf(outtt, "\n%s            %s\n\n",resname1, date);

                        fprintf(outtt, "%s\n\n"," Hour     Elev.      Tail      Head      Gen.   Pow_rel  Spillway    Bypass    Tot_rel");

                        for(i=0; i <= 23; i++)
                        {
                          fprintf(outtt,"%5d%10.2f%10.2f%10.2f%10.0f%10.0f%10.0f%10.0f%10.0f\n",
                          hour[i][j],elev[i][j],tail[i][j],head[i][j],gen[i][j],pow_rel[i][j],spill[i][j],bypass[i][j],riv[i][j]);
                         }

                         fprintf(outtt,"\n%s%10.2f%10.2f%10.2f%10.0f%10.0f%10.0f%10.0f%10.0f\n",
                                "Aver.",aelev[j],atail[j],ahead[j],agen[j],apow_rel[j],aspill[j],abypass[j],ariv[j]);
   
                         fprintf(outtt,"%s                                        %10.0f%10.0f%10.0f%10.0f\n",
                           "Total",pow_relaf[j],spillaf[j],bypassaf[j],rivaf[j]);    

                         fprintf(outtt,"%s\n","A.F.");         
                         }


                   if (j == 1)
                       {
                        fprintf(out, "\n%s            %s\n\n",resname2, date);
                       }


                   if (j == 2)
                       {
                        fprintf(out, "\n%s            %s\n\n",resname3, date);
                       }


                   if (j == 3)
                       {
                        fprintf(out, "\n%s            %s\n\n",resname4, date);
                       }


                   if (j == 4)
                       {
                        fprintf(out, "\n%s            %s\n\n",resname5, date);
                       }

                   if (j == 5)
                       {
                        fprintf(out, "\n%s            %s\n\n",resname6, date);
                       }

                   fprintf(out, "%s\n\n"," Hour     Elev.      Tail      Head      Gen.   Pow_rel  Spillway    Bypass    Tot_rel");

                   for(i=0; i <= 23; i++)
                        {
                          fprintf(out,"%5d%10.2f%10.2f%10.2f%10.0f%10.0f%10.0f%10.0f%10.0f\n",
                          hour[i][j],elev[i][j],tail[i][j],head[i][j],gen[i][j],pow_rel[i][j],spill[i][j],bypass[i][j],riv[i][j]);
                         }

                    fprintf(out,"\n%s%10.2f%10.2f%10.2f%10.0f%10.0f%10.0f%10.0f%10.0f\n",
                           "Aver.",aelev[j],atail[j],ahead[j],agen[j],apow_rel[j],aspill[j],abypass[j],ariv[j]);

                    fprintf(out,"%s                                        %10.0f%10.0f%10.0f%10.0f\n",
                           "Total",pow_relaf[j],spillaf[j],bypassaf[j],rivaf[j]);    

                    fprintf(out,"%s\n","A.F.");         
                  }

                   fclose(out);
                   fclose(outtt);

                   for (j=0; j<=5; j++)
                   {
                        bypassaf1[j] = bypassaf[j] + spillaf[j];
                   }

                   for (j=0; j<=5; j++)
                    {
                    if (j == 0)
                        {
                         fprintf(outt,"    %s %s      %s%8.2f  %s%8.0f  %s%8.0f\n", "GLDA",date,"FB",
                                elev[23][j],"PWRREL", pow_relaf[j],"OTHREL",bypassaf1[j]);
                        }

                    if (j == 1)
                        {
                         fprintf(outt,"    %s %s      %s%8.2f  %s%8.0f  %s%8.0f\n", "MPRC",date,"FB",
                                elev[23][j],"PWRREL", pow_relaf[j],"OTHREL",bypassaf1[j]);
                        }

                    if (j == 2)
                        {
                         fprintf(outt,"    %s %s      %s%8.2f  %s%8.0f  %s%8.0f\n", "BMDC",date,"FB",
                                elev[23][j],"PWRREL", pow_relaf[j],"OTHREL",bypassaf1[j]);
                        }

                    if (j == 3)
                        {
                         fprintf(outt,"    %s %s      %s%8.2f  %s%8.0f  %s%8.0f\n", "CRRC",date,"FB",
                                elev[23][j],"PWRREL", pow_relaf[j],"OTHREL",bypassaf1[j]);
                        }

                    if (j == 4)
                        {
                         fprintf(outt,"    %s %s      %s%8.2f  %s%8.0f  %s%8.0f\n", "FGRU",date,"FB",
                                elev[23][j],"PWRREL", pow_relaf[j],"OTHREL",bypassaf1[j]);
                        }

                    if (j == 5)
                        {
                         fprintf(outt,"    %s %s      %s%8.2f  %s%8.0f  %s%8.0f\n", "FTRW",date,"FB",
                                elev[23][j],"PWRREL", pow_relaf[j],"OTHREL",bypassaf1[j]);
                        }

                     }

                     fclose(outt);

              if ((out5 = fopen("./hydromet.dat","w+")) == NULL)
                {
                 fprintf(stderr, "can't open output5 for writing\n");
                 exit(1);
                 }   


                   for (j=0; j<=5; j++)
                    {
                    if (j == 0)
                        {
                         fprintf(out5,"    %s %s      %s%8.2f  %s%8.0f  %s%8.0f\n", "GLDA",date,"FB",
                                elev[23][j],"PWRREL", pow_relaf[j],"OTHREL",bypassaf1[j]);
                        }

                    if (j == 1)
                        {
                         fprintf(out5,"    %s %s      %s%8.2f  %s%8.0f  %s%8.0f\n", "MPRC",date,"FB",
                                elev[23][j],"PWRREL", pow_relaf[j],"OTHREL",bypassaf1[j]);
                        }

                    if (j == 2)
                        {
                         fprintf(out5,"    %s %s      %s%8.2f  %s%8.0f  %s%8.0f\n", "BMDC",date,"FB",
                                elev[23][j],"PWRREL", pow_relaf[j],"OTHREL",bypassaf1[j]);
                        }

                    if (j == 3)
                        {
                         fprintf(out5,"    %s %s      %s%8.2f  %s%8.0f  %s%8.0f\n", "CRRC",date,"FB",
                                elev[23][j],"PWRREL", pow_relaf[j],"OTHREL",bypassaf1[j]);
                        }

                    if (j == 4)
                        {
                         fprintf(out5,"    %s %s      %s%8.2f  %s%8.0f  %s%8.0f\n", "FGRU",date,"FB",
                                elev[23][j],"PWRREL", pow_relaf[j],"OTHREL",bypassaf1[j]);
                        }

                    if (j == 5)
                        {
                         fprintf(out5,"    %s %s      %s%8.2f  %s%8.0f  %s%8.0f\n", "FTRW",date,"FB",
                                elev[23][j],"PWRREL", pow_relaf[j],"OTHREL",bypassaf1[j]);
                        }

                     }

                      fclose(out5);

} /* end of main */

