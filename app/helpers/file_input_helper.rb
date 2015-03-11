# Provide helper to active boostrap File input capacity on for file parameter
module FileInputHelper
    # Extend FormBuilder to provide bootstrap_fileinput helper
    class ActionView::Helpers::FormBuilder
        def bootstrap_fileinput(name, options)
            options[:id] ||= "#{@object_name}_#{name}"
            options[:name] ||= "#{@object_name}[#{name}]"

            @template.bootstrap_fileinput(options)
        end
    end

    def bootstrap_fileinput(options)
        options ||= {}
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

    protected

    def self.parse_options(options)
        [parse_input_options(options), parse_js_options(options)]
    end

    def self.parse_input_options(options)
        opts_ipt = {
            id: :input_id, type: :file, class: :file, multiple: false,
            'data-preview-file-type' => :text, 'data-show-caption' => nil,
            'data-show-preview' => nil, accept: 'image/*'
        }
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
