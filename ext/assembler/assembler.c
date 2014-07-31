#include "ruby.h"
#include <stdlib.h>

VALUE Bloom = Qnil;
VALUE Assembler = Qnil;

void Init_assembler();

// methods called by ruby
VALUE BloomInit(VALUE, VALUE, VALUE, VALUE);

// methods called by c
void add(char *);
long hash(char *, int, int, int);

// variables
long set_len;
int set_count;
uint8_t *set;
int kmer_size;

// initialisation method for this module
void Init_assembler() {
    Assembler = rb_define_module("Assembler");
    Bloom = rb_define_class_under(Assembler, "Bloom", rb_cObject);
    rb_define_method(Bloom, "initialize", BloomInit, 3);
    // rb_define_method(AssemblerClass, "add", method_add, 1);
}

VALUE BloomInit(VALUE self, VALUE size, VALUE count, VALUE ks) {
	long i;
	set_len = NUM2INT(size);
	set_count = NUM2INT(count);
	kmer_size = NUM2INT(ks);
	set = malloc(set_count * set_len * sizeof(uint8_t));
    for (i = 0; i < set_len * set_count; i++) {
        set[i] = 0;
    }
	return Qnil;
}

void add(char * read) {
    int b, start, len;
    long h;
    uint8_t count;
    len = strlen(read) - kmer_size;
    for (start = 0; start < len; start++) {
        for (b = 0; b < set_count; b++) {
            h = hash(read, start, kmer_size, b);
            count = set[b*set_len+h];
            if (count < 254) {
                set[b*set_len+h]++;
            }
        }
    }
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
    if (hash2 > hash) {
        hash2 = hash2 % set_len;
        return hash2;
    } else {
        hash = hash % set_len;
        return hash;
    }
}