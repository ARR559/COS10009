require "./input_functions"
# put your code here - make sure you use the input_functions to read strings and integers
def read_details()
    #prints name and title
    title=read_string('Please enter your title: (Mr, Mrs, Ms, Miss, Dr)')
    first_name=read_string('Please enter your first name:')
    last_name=read_string('Please enter your last name:')
    user_details = title +" "+ first_name +" "+ last_name
    return user_details
end

def read_address()
    #prints address
    house_number = read_string('Please enter the house or unit number:')
    street_name = read_string('Please enter the street name:')
    suburb = read_string('Please enter the suburb:')
    post_code = read_integer_in_range('Please enter a postcode (0000 - 9999)',0,9999)
    user_address = house_number +" "+ street_name +"\n"+ suburb +" "+ post_code.to_s
    return user_address
end

def read_label()
    reciever_name = read_details()
    reciever_address = read_address()
    return reciever_name+ "\n" +reciever_address+ "\n" 
end


def read_message()
    #prinnts the message
    subject = read_string('Please enter your message subject line:')
    content = read_string('Please enter your message content:')
    user_message = "RE: " +subject+"\n\n"+content
    return user_message
end

def send_message_to_address(label,message)
   puts(label)
   puts(message)
end
    
def main()
   label = read_label()
   message = read_message()
   send_message_to_address(label,message)
end

main()

