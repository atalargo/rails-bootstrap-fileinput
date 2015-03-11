module FileInputHelper
    def bootstrap_fileinput(options)
        options = options || {}
        options_input, options_js = FileInputHelper.parse_options(options)

        tag(:input, options_input) <<
            javascript_tag("$(document).on(\'ready page:load\', function() {\
                var opts_ips = JSON.parse('#{options_js.to_json.gsub(/'/, '\\\'')}');
                console.log(opts_ips);
                $('##{options_input[:id]}').fileinput(
                    JSON.parse('#{options_js.to_json.gsub(/'/, '\\\'')}')
                );
            });")
        # tag(:input,
        #     id: :input_id,
        #     type: :file,
        #     class: :file,
        #     'preview-file-type' => :text
        # ) <<
        #     javascript_tag('$(document).on(\'ready page:load\') {\
        #          $("#input-id").fileinput();\
        #     }')
    end

    def self.parse_options(options)
        [parse_input_options(options), parse_js_options(options)]
    end

    protected

    def self.parse_input_options(options)
        opts_ipt = {
            id: :input_id,
            type: :file,
            class: :file,
            multiple: false,
            'data-preview-file-type' => :text,
            'data-show-caption' => nil,
            'data-show-preview' => nil,
            accept: 'image/*'
        }
        # opts_ipt = opts_ipt.merge(options.reject { |k, _| opts_ipt[k].nil? })
        opts_ipt.reject { |_k, v| v.nil? }.merge(options.reject { |k, _| opts_ipt[k].nil? })
    end

    def self.parse_js_options(options)
        opts_js  = {
            allowedFileTypes: ['image'],
            allowedFileExtensions: [:jpg, :jpeg, :png],
            initialCaption: ''
        }
        opts_js.reject { |_k, v| v.nil? }.merge(options.reject { |k, _| opts_js[k].nil? })
    end
end
