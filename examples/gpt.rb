$:.unshift File.join(File.dirname(__FILE__),'../lib')
require 'rbstruct'
dev = ARGV[0]

raise Exception.new('No dev') unless dev

GptHeader = RbStruct do
  unsigned_char :signature, 8
  unsigned_int  :revision
  unsigned_int  :header_size
  unsigned_int  :crc32
  unsigned_int  :revserved
  unsigned_long :current_lba
  unsigned_long :backup_lba
  unsigned_long :first_lba
  unsigned_long :last_lba
  unsigned_char :guid, 16
  unsigned_long :partition_array_lba
  unsigned_int  :n_partition_array
  unsigned_int  :partition_entry_size
  unsigned_int  :partition_array_crc32
end

GptPartEntry = RbStruct do
  unsigned_char :part_type_guid, 16
  unsigned_char :part_guid, 16
  unsigned_long :last_lba
  unsigned_long :attributes
  unsigned_char :name, 72
end



file = open(dev, 'r+')

file.seek(512)
header = RbStruct::read_struct(file, GptHeader).first

file.seek(512*header.backup_lba)
backup = RbStruct::read_struct(file, GptHeader).first

puts "Primary header"
puts header.inspect
puts "----------------------------------------"
puts "Backup header"
puts backup.inspect
