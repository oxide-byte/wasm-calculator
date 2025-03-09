(module
 (type $0 (func (param i32 i32) (result i32)))
 (memory $0 0)
 (export "adder" (func $src/adder/adder))
 (export "memory" (memory $0))
 (func $src/adder/adder (param $0 i32) (param $1 i32) (result i32)
  local.get $0
  local.get $1
  i32.add
 )
)
