(module
  (func (export "sub") (param $a i32) (param $b i32) (result i32)
    local.get $a
    local.get $b
    i32.sub
  )
)