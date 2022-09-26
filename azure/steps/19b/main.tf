resource "scratch_bool" "this" {
  in = false
}

resource "scratch_string" "this" {
  in = "create_before_destroy"

  lifecycle {
    replace_triggered_by = [
      scratch_bool.this
    ]
  }
}

#Try changing scratch_bool.this.in = true. It should destroy and create scratch_string also