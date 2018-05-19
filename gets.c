char *gets(char *s)
{
	int c;
 	char *dest = s;
	while((c=getchar())!='\n'&&c!= -1)
		*dest++=c;
	if(c == -1 && dest ==s )
		return 0;
	*dest++='\0';
	return s;
}
void echo()
{
	char buf[8];
	gets(buf);
	puts(buf);
}
