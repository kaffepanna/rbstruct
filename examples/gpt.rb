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
header = GptHeader.read(file)

file.seek(512*header.partition_array_lba)
lbas = GptPartEntry.read(file, header.n_partition_array)
file.seek(512*header.backup_lba)
backup = GptHeader.read(file)


puts "Primary header"
puts header.inspect
puts "----------------------------------------"

lbas.reject { |l| l.last_lba == 0 }.each do |l|
	puts l.inspect
end

puts "----------------------------------------"
puts "Backup header"
puts backup.inspect
