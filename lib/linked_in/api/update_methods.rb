require 'xmlsimple'

module LinkedIn
  module Api

    module UpdateMethods

      def add_share(share)
        path = "/people/~/shares"
        share_h = { 
          visibility: { code: "anyone" }, 
          comment: share[:comment]
        }
        
        share_h.merge!(:'submitted-url' => share[:submitted_url]) if share[:submitted_url]
        share_h.merge!(:'submitted-image-url' => share[:submitted_image_url]) if share[:submitted_image_url]
        share_h.merge!(:description => share[:description]) if share[:description]
        
        body = { share: share_h }
        post(path, body: hash_to_xml(body), headers: {"Content-Type" => "application/xml"})
      end

      def join_group(group_id)
        path = "/people/~/group-memberships/#{group_id}"
        body = {'membership-state' => {code: 'member' }}
        put(path, body: hash_to_xml(body), headers: {"Content-Type" => "application/xml"})
      end

      def add_job_bookmark(bookmark)
        path = "/people/~/job-bookmarks"
        body = {job: {id: bookmark}}
        post(path, body: hash_to_xml(body), headers: {"Content-Type" => "application/xml"})
      end

      # def share(options={})
      #   path = "/people/~/shares"
      #   defaults = { visability: 'anyone' }
      #   post(path, share_to_xml(defaults.merge(options)))
      # end
      #
      def update_comment(network_key, comment)
        path = "/people/~/network/updates/key=#{network_key}/update-comments"
        body = {comment: comment}
        post(path, body: hash_to_xml(body), headers: {"Content-Type" => "application/xml"})
      end
      #
      # def update_network(message)
      #   path = "/people/~/person-activities"
      #   post(path, network_update_to_xml(message))
      # end
      #

      def like_share(network_key)
        path = "/people/~/network/updates/key=#{network_key}/is-liked"
        body = {'is-liked' => true}
        put(path, body: hash_to_xml(body), headers: {"Content-Type" => "application/xml"})
      end

      def unlike_share(network_key)
        path = "/people/~/network/updates/key=#{network_key}/is-liked"
        body = {'is-liked' => false}
        put(path, body: hash_to_xml(body), headers: {"Content-Type" => "application/xml"})
      end

      def send_message(subject, body, recipient_paths)
        path = "/people/~/mailbox"
        recipient_paths = Array(recipient_paths)

        message = { 'mailbox-item' => {
            'subject' => subject,
            'body' => body,
            'recipients' => {
                'recipient' => recipient_paths.map do |profile_path|
                  { 'person' => { '@path' => "/people/#{profile_path}" } }
                end
            } }
        }
        post(path, body: hash_to_xml(message), headers: {"Content-Type" => "application/xml"})
      end

      private

        def hash_to_xml(hash)
          ::XmlSimple.xml_out(hash, keeproot: 1, noindent: true, attrprefix: true  )
        end

    end

  end
end
