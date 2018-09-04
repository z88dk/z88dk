/* Simple CP/M disc writer - wraps it all up in an EDSK file */


#include "appmake.h"


struct cpm_handle_s {
    cpm_discspec  spec;

    uint8_t      *image;
};


cpm_handle *cpm_create(cpm_discspec *spec) 
{
     cpm_handle *h = calloc(1, sizeof(*h));
     size_t      len;
     
     h->spec = *spec;

     len = spec->tracks * spec->sectors_per_track * spec->sector_size;
     h->image = calloc(len, sizeof(char));
     memset(h->image, spec->filler_byte, len);
     return h;
}

void cpm_write_boot_track(cpm_handle *h, void *data, size_t len) 
{
     memcpy(h->image, data, len);
}


void cpm_write_file(cpm_handle *h, char filename[11], void *data, size_t len)
{
      size_t num_extents = (len / h->spec.extent_size) + 1;
      size_t directory_offset = (h->spec.boottracks * h->spec.sectors_per_track * h->spec.sector_size);
      size_t offset = directory_offset + (h->spec.directory_entries * 32);
      uint8_t *dir_ptr = h->image + directory_offset;
      uint8_t  direntry[32];
      uint8_t  *ptr;
      int      i, j, current_extent;

      memcpy(h->image + offset, data, len);


      // Now, write the directory entry, we can start from extent 1
      current_extent = 1;
      for ( i = 0; i <= (num_extents / 8)  ; i++ ) {
          int extents_to_write;

          memset(direntry, 0 ,sizeof(direntry));

          direntry[0] = 0;  // User 0
          memcpy(direntry + 1, filename, 11);
          direntry[12] = i;   // Extent number
          direntry[13] = 0;
          direntry[14] = 0;
          if ( num_extents - ( i * 8) > 8) {
              direntry[15] = 0x80;
              extents_to_write = 8;
          } else {
              direntry[15] = (num_extents - ( i * 8)) * 8;   // Record count
              extents_to_write = (num_extents - ( i * 8));
          }
	printf("Extents to write %d\n",extents_to_write);
          ptr = &direntry[16];
          for ( j = 0; j < 8; j++ ) {
              if ( j < extents_to_write ) {
                 direntry[j * 2 + 16] = (current_extent) % 256;
                 direntry[j * 2 + 16 + 1] = (current_extent) / 256;
                 current_extent++;
              } else {
			printf("skipping\n");
		}
          }
          memcpy(h->image + directory_offset, direntry, 32);
          directory_offset += 32;
      } 
}

int cpm_write_image(cpm_handle *h, const char *filename)
{
      uint8_t header[256] = {0};
      FILE  *fp;
      int    i,j;

      if ( ( fp = fopen(filename, "wb")) == NULL ) {
          return -1;
      }
      memset(header, 0, 256);
      memcpy(header, "EXTENDED CPC DSK FILE\r\nDisk-Info\r\n",34);
      memcpy(header + 0x22, "z88dk", 5);
      header[0x30] = h->spec.tracks;
      header[0x31] = h->spec.sides;
      for ( i = 0; i < h->spec.tracks; i++ ) {
          header[0x34+i] = (h->spec.sector_size * h->spec.sectors_per_track + 256) / 256;
      }
      fwrite(header, 256, 1,  fp);

      for ( i = 0; i < h->spec.tracks; i++ ) {
          uint8_t *ptr;
          memset(header, 0, 256);
          memcpy(header, "Track-Info\r\n",12);
          header[0x10] = i;
          header[0x11] = 0; // side
          header[0x14] = h->spec.sector_size / 256;
          header[0x15] = h->spec.sectors_per_track;
          header[0x16] = h->spec.gap3_length;
          header[0x17] = h->spec.filler_byte;
          ptr = header + 0x18;
          for ( j = 0; j < h->spec.sectors_per_track; j++ ) {
             *ptr++ = i;  // Track
             *ptr++ = 0;  // Side
             *ptr++ = j;  // Secotr ID
             *ptr++ = h->spec.sector_size / 256;
             *ptr++ = 0; // FDC status register 1
             *ptr++ = 0; // FDC status register 2
             *ptr++ = h->spec.sector_size % 256;
             *ptr++ = h->spec.sector_size / 256;
          }
          fwrite(header, 256, 1, fp);
          fwrite(h->image + (i * h->spec.sector_size * h->spec.sectors_per_track), h->spec.sector_size * h->spec.sectors_per_track, 1, fp);
      }
      fclose(fp);
      return 0;
}


void cpm_free(cpm_handle *h)
{
     free(h->image);
     free(h);
}
