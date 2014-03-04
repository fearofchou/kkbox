@outputSchema("word:chararray")
def helloworld():  
  return 'Hello, World'

@outputSchema("word:chararray,num:long")
def complex(word):
  return str(word),len(word)

@outputSchemaFunction("squareSchema")
def square(num):
  return ((num)*(num))

@schemaFunction("squareSchema")
def squareSchema(input):
  return input

# No decorator - bytearray
def concat(str):
  return str+str

@outputSchema("logs: {(user_id:int, artist_id:int, song_id:int, time_string:chararray)}")
def enumerate_bag(input):
    output = 0
    for user_id in enumerate(input):
        output+=1;
    return output	
