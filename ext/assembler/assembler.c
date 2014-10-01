#include "ruby.h"
#include <stdlib.h>

VALUE Bloom = Qnil;
VALUE Assembler = Qnil;

void Init_assembler();

// methods called by ruby
VALUE BloomInit(VALUE, VALUE, VALUE, VALUE);
VALUE method_add(VALUE, VALUE);
VALUE method_get(VALUE, VALUE);

// methods called by c
void add_c(char *);
uint8_t get_c(char *);
long hash(char *, int, int, int);

// variables
long set_len;
int set_count;
uint8_t *set;
int kmer_size;
long *offsets;

// primes
// 104395303, 112936403, 115450637, 117959551, 119607757, 122076281, 122091313
// initialisation method for this module
void Init_assembler() {
  Assembler = rb_define_module("Assembler");
  Bloom = rb_define_class_under(Assembler, "Bloom", rb_cObject);
  rb_define_method(Bloom, "initialize", BloomInit, 3);
  rb_define_method(Bloom, "add", method_add, 1);
  rb_define_method(Bloom, "get", method_get, 1);
}

/*
*  size:  size of bloom filter tables
*  count: number of tables
*  ks:    kmer size
*/
VALUE BloomInit(VALUE self, VALUE size, VALUE count, VALUE ks) {
  long i;
  set_len = NUM2INT(size);
  set_count = NUM2INT(count);
  kmer_size = NUM2INT(ks);
  set = malloc(set_count * set_len * sizeof(uint8_t));
  for (i = 0; i < set_len * set_count; i++) {
    set[i] = 0;
  }
  offsets = malloc(7 * sizeof(long));
  offsets[0] = 104395303;
  offsets[1] = 112936403;
  offsets[2] = 115450637;
  offsets[3] = 117959551;
  offsets[4] = 119607757;
  offsets[5] = 122076281;
  offsets[6] = 122091313;
  return Qnil;
}

void add_c(char * read) {
  int b, start, len;
  long h;
  uint8_t count;
  len = strlen(read) - kmer_size + 1;
  for (start = 0; start < len; start++) {
    // printf("%i\t%i\n",start,len);
    for (b = 0; b < set_count; b++) {
      h = hash(read, start, kmer_size, b);
      count = set[b*set_len+h];
      if (count < 254) {
        set[b*set_len+h]++;
      }
    }
  }
}

VALUE method_add(VALUE self, VALUE _str) {
  char * str = StringValueCStr(_str);
  add_c(str);
  return INT2NUM(0);
}

uint8_t get_c(char * kmer) {
  int b;
  long h;
  uint8_t p,v=255;
  for (b = 0; b < set_count; b++) {
    h = hash(kmer, 0, kmer_size, b);
    p = set[b*set_len+h];
    if (p < v) {
      v = p;
    }
  }
  return v;
}

VALUE method_get(VALUE self, VALUE _kmer) {
  int c;
  char * kmer = StringValueCStr(_kmer);
  c = get_c(kmer);
  return INT2NUM(c);
}

//calculates the hashing function on a kmer and the
// reverse complement of that kmer and takes the larger
// of the two and return it.
long hash(char * str, int start, int len, int n) {
  int i;
  long hash=0, hash2=0;
  for(i = start; i < start+len; i++) {
    hash = hash << 2;
    if (str[i]=='A') {
      hash += 0;
    } else if (str[i]=='C') {
      hash += 1;
    } else if (str[i]=='G') {
      hash += 2;
    } else if (str[i]=='T') {
      hash += 3;
    }
    // hash = hash % set_len;
  }
  // calculate reverse complement hashing function
  for(i = start+len-1;i>=start; i--) {
    hash2 = hash2 << 2;
    if (str[i]=='A') {
      hash2 += 3;
    } else if (str[i]=='C') {
      hash2 += 2;
    } else if (str[i]=='G') {
      hash2 += 1;
    } else if (str[i]=='T') {
      hash2 += 0;
    }
    // hash2 = hash2 % set_len;
  }
  hash += offsets[n];
  hash2 += offsets[n];
  // printf("%li\t%li\n",hash,hash2);
  if (hash2 > hash) {
    hash2 = hash2 % set_len;

    return hash2;
  } else {
    hash = hash % set_len;

    return hash;
  }
}