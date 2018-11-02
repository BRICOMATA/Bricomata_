/* XFETCH  - routine to retrieve contents of cut buffer zero.
 *
 *           This routine will return a single line from the
 *           buffer at each call.
 *
 *           buffer_open    - 0 => buffer currently not open
 *                            1 => buffer currently open
 *           iptr           - current position in buffer
 *
 */
#if APPEND_UNDERSCORE == 1 && SUBROUTINE_CASE == 1
void xfetch(buffer_open, iptr, nval, istr)
#elif APPEND_UNDERSCORE == 1 && SUBROUTINE_CASE == 0
void XFETCH(buffer_open, iptr, nval, istr)
#elif APPEND_UNDERSCORE == 0 && SUBROUTINE_CASE == 1
void xfetch(buffer_open, iptr, nval, istr)
#elif APPEND_UNDERSCORE == 0 && SUBROUTINE_CASE == 0
void XFETCH(buffer_open, iptr, nval, istr)
#endif
#if INTEGER_PRECISION == 0
int    *buffer_open;
int    *iptr;
int    *nval;
#else
int    buffer_open[2];
int    iptr[2];
int    nval[2];
#endif
int    istr[];

{
   int buffer_open_temp;
   int iptr_temp;
   int nbytes_return;
   int nbytes_max;
   int buffer;
   int iflag;
   int iflag_close;
   int nval_temp;
   int ival;
   int ivaln;
   char * bytes_return;
   char *chrtemp;
   char *chrtempn;

   /* Step 0: Initialize */
#if INTEGER_PRECISION == 0
   buffer_open_temp = *buffer_open;
   iptr_temp = *iptr;
#else
   buffer_open_temp = buffer_open[0];
   iptr_temp = iptr[0];
#endif

   /* Step 1: fetch contents of buffer */
   if (buffer_open_temp == 0) {
      bytes_return = XFetchBuffer(display, &nbytes_return);
      nbytes_max = nbytes_return;
      if (nbytes_return > 0) {
#if INTEGER_PRECISION == 0
         *buffer_open = 1;
#else
         buffer_open[0] = 1;
#endif
         iptr_temp = 0;
         nbytes_max = nbytes_return;
      } else {
         if (bytes_return) XFree(bytes_return);
#if INTEGER_PRECISION == 0
            iptr = 0;
            nval = 0;
#else
            iptr[0] = 0;
            nval[0] = 0;
#endif
         return;
      }
    
   }

   /* Step 2: Retrieve next record from buffer */
   iflag = 0;
   iflag_close = 0;
   nval_temp  = 0;

   while (iflag == 0) {
       iptr_temp = iptr_temp + 1;
       if ((nbytes_return > 0) && (iptr_temp <= nbytes_max)) {
          *chrtemp = bytes_return[iptr_temp];
          ival = *chrtemp;
          /* CR/LF character encountered  */
          if ((ival == 10) || (ival == 13)) {
             iptr_temp = iptr_temp + 1;
             *chrtempn = bytes_return[iptr_temp+1];
             ivaln = *chrtempn;
             if ((ival == 10) && (ivaln == 13)) {
                iptr_temp = iptr_temp + 1;
             }
             if ((ival == 13) && (ivaln == 10)) {
                iptr_temp = iptr_temp + 1;
             }
             iflag = 1;
          /* NULL byte encountered */
          } else if (ival == 0) {
             iflag_close = 1;
          /* Add next character to current record */
          } else {
             nval_temp = nval_temp + 1;
             istr[nval_temp] = *chrtemp;
          }
       }
   }
#if INTEGER_PRECISION == 0
   *iptr = iptr_temp;
   *nval = nval_temp;
#else
   iptr[0] = iptr_temp;
   nval[0] = nval_temp;
#endif
   if (iptr_temp >= nbytes_max) iflag_close = 1;

   /* Step 3: If end of buffer reached, then free contents of buffer */
   if ((iflag_close == 1) && (bytes_return)) XFree(bytes_return);
#if INTEGER_PRECISION == 0
      *buffer_open = 0;
#else
      buffer_open[0] = 0;
#endif

}

