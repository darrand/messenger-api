class ConversationsController < ApplicationController
    # GET /conversations
    def index
        authorizer = AuthorizeApiRequest.new(request.headers)
        res = authorizer.call
        user = res[:user]
        @convo = Conversation.where(user1_id: user.id).or(Conversation.where(user2_id: user.id))
        @res = []
        for i in @convo do
            convo_id = i.id
            convo_partner = User.find(i.user2_id)
            msg = Message.where(conversation_id: convo_id).last
            with_user = { 
                'id' => convo_partner.id,
                'name' => convo_partner.name,
                'photo_url' => convo_partner.photo_url
            }
            last_message = {
                'id' => msg.id,
                'sender' => {
                    'id' => msg.sender.id,
                    'name' => msg.sender.name
                },
                'sent_at' => msg.created_at
            } # TODO
            unread_count = i.user1_unread_count
            ret_data = {
                "id" => i.id,
                "with_user" => with_user,
                "last_message" => last_message,
                "unread_count" => unread_count,
            }
            @res.push(ret_data)
        end
        # TODO : query message terakhir pakai id convo diatas
        # TODO : Unread count explore tambah field unread count user1 & user2 di convo model, bikin post route message, set integer message convo

        json_response(@res)
    end

    # GET /conversations/:id
    def show
        authorizer = AuthorizeApiRequest.new(request.headers)
        res = authorizer.call
        user_logon = res[:user]
        convo = Conversation.find(params[:id])
        if user_logon.id == convo.user1_id
            convo_partner = User.find(convo.user2_id)
        else
            convo_partner = User.find(convo.user1_id)
        end
        @res = {
            "id" => convo.id,
            "with_user" => {
                "id" => convo_partner.id,
                "name" => convo_partner.name,
                "photo_url" => convo_partner.photo_url
            }
        }
        json_response(@res)
    end
end
