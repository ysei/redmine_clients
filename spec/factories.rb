Factory.define :client do |f|
  f.name 'Citrus Inc'
  f.phone '01-2345-6789'
  f.fax '98-7654-3210'
  f.postal '100-0000'
  f.address 'Lorem Ipsum'
  f.description ''
end

Factory.define :representative do |f|
  f.name "John"
end
