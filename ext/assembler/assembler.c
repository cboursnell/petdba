#include "ruby.h"
#include <stdlib.h>

VALUE AssemblerClass = Qnil;
VALUE AssemblerModule = Qnil;

void Init_assembler();

void Init_assembler() {
    AssemblerModule = rb_define_module("Assembler");
    AssemblerClass = rb_define_class_under(AssemblerModule, "Assembler", rb_cObject);
    // rb_define_method(AssemblerClass, "add", method_add, 1);
}