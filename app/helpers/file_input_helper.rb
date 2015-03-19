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

    def bootstrap_fileinput_preview(files)
        files.map do |file|
            image_tag(file[:url], alt: file[:name], title: file[:name], class: 'file-preview-image' )
        end
    end

    def bootstrap_fileinput(options)
        options ||= {}
        options_input, options_js = FileInputHelper.parse_options(options)

        unless options_js[:initialPreview].nil?
            previews = options_js[:initialPreview]
            options_js.delete :initialPreview
            options_js[:initialPreview] = bootstrap_fileinput_preview(previews)
            options_js[:initialPreviewConfig] = previews.map do |preview|
                { id: preview[:key], caption: preview[:name], url: preview[:delete], width: '120px' }
            end
        end

        slugCallback = options_js[:slugCallback]
        options_js.delete :slugCallback

        tag(:input, options_input) <<
            raw("<script type=\"text/javascript\">$(document).on('ready page:load', function() {\
                $('##{options_input[:id]}').fileinput({
                    #{options_js.map { |k, v| "#{k}: #{v.to_json}," }.join("\n") }
                    #{slugCallback ? 'slugCallback: ' + slugCallback : ''}
                });
            });</script>")
    end

    protected

    def self.parse_options(options)
        [parse_input_options(options), parse_js_options(options)]
    end

    def self.parse_input_options(options)
        opts_ipt = {
            id: :input_id, name: :input_file, type: :file, class: :file, multiple: false,
            'data-preview-file-type' => :text, 'data-show-caption' => nil,
            'data-show-preview' => nil, accept: 'image/*', 'data-show-upload' => nil
        }
        opts_ipt.reject { |_k, v| v.nil? }.merge(options.reject { |k, _| !opts_ipt.include?(k) })
    end

    def self.parse_js_options(options)
        opts_js  = {
            allowedFileTypes: ['image'],
            allowedFileExtensions: [:jpg, :jpeg, :png],
            initialCaption: '', slugCallback: nil,
            showUpload: true, uploadAsync: true, uploadUrl: nil,
            browseClass: 'btn btn-primary btn-file', browseLabel: 'Browse...', browseIcon: nil,
            initialPreview: nil, overwriteInitial: true, layoutTemplates: nil
        }
        opts_js.reject { |_k, v| v.nil? }.merge(options.reject { |k, _| !opts_js.include?(k) })
    end
end
