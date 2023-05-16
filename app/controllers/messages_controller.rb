class MessagesController < ApplicationController
    # GET /conversations/:id/messages
    def index
        authorizer = AuthorizeApiRequest.new(request.headers)
        res = authorizer.call
        user = res[:user]
        puts(user.id)
        puts(params[:conversation_id])
        puts(user.id === params[:conversation_id])
        if user.id == params[:conversation_id].to_i
            convo = Conversation.where(user1_id: user.id).or(Conversation.where(user2_id: user.id))
        # else
        #     # Raise error 403 
        end
        msgs = Message.where(conversation_id: convo[0].id)
        @res = []
        for m in msgs do
            m_id = m.id
            msg = m.message
            sender = {
                "id" => m.sender.id,
                "name" => m.sender.name,
            }
            last_sent = m.created_at
            ret_data = {
                "id" => m_id,
                "message" => msg,
                "sender" => sender,
                "sent_at" => last_sent
            }
            @res.push(ret_data)
        end
        json_response(@res)
    end

    # POST /messages
    def create
    end
    
end
