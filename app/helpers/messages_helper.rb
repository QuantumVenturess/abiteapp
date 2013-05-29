module MessagesHelper

  include ApplicationHelper

  def message_to_json(message)
    hash = {
      content: message.content,
      created_at: nsdate_format(message.created_at),
      id: message.id,
      table: message.table.attributes,
      table_id: message.table.id,
      updated_at: nsdate_format(message.updated_at),
      user: message.user.attributes,
      user_id: message.user.id
    }
  end

  def messages_to_json(messages)
    array = []
    messages.each do |message|
      hash = {
        content: message.content,
        created_at: nsdate_format(message.created_at),
        id: message.id,
        table: message.table.attributes,
        table_id: message.table.id,
        updated_at: nsdate_format(message.updated_at),
        user: message.user.attributes,
        user_id: message.user.id
      }
      array.append(hash)
    end
    array
  end

end