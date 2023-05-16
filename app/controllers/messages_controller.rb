class MessagesController < ApplicationController
    # GET /conversations/:id/messages
    def index
        authorizer = AuthorizeApiRequest.new(request.headers)
        res = authorizer.call
        user = res[:user]
        convo_val = Conversation.find_by(id: params[:id])
        if convo_val == nil
            return head :not_found
        end
        if user.id != params[:conversation_id].to_i
            return head :forbidden
        end
        convo = Conversation.where(user1_id: user.id).or(Conversation.where(user2_id: user.id))
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
        authorizer = AuthorizeApiRequest.new(request.headers)
        res = authorizer.call
        user = res[:user]
        sender_id = user.id
        user_msg = params[:message]
        receiver_id = params[:user_id]
        convo = Conversation.where(user1_id: sender_id, user2_id: receiver_id).or(Conversation.where(user1_id: receiver_id, user2_id: sender_id))
        if convo.length == 0
            convo_new = Conversation.create(user1_id: sender_id, user2_id: receiver_id)
        else
            convo_new = convo[0]
        end
        @msg = Message.create!(message: user_msg, sender_id: sender_id, conversation_id: convo_new.id)
        json_response(@msg, :created)
    end
    
end
