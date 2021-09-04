variable "user" {
    type = string
    default = "bambang_satrijotomo"
}

variable "vmcount" {
    type = number
    default = 3 
}

variable "privatekeypath" {
    type = string
    default = "~/.ssh/gcpkey"
}
variable "publickeypath" {
    type = string
    default = "~/.ssh/gcpkey.pub"
}