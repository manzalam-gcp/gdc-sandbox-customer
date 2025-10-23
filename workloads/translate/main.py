import os
import requests # Use requests for HTTP calls
from flask import Flask, request, jsonify

app = Flask(__name__)

TRANSLATE_API_URL = 'https://translation.googleapis.com/language/translate/v2'
TRANSLATE_APP_API_KEY = os.environ['TRANSLATE_APP_API_KEY']


@app.route('/', methods=['GET'])
def home():
    print(request.headers)
    return jsonify({"_message":"This is the translate app.", 
                    "request":{"headers":{"User-Agent":request.headers.get('User-Agent')},
                                "args":request.args,
                                "origin":request.remote_addr,
                               }})


@app.route('/translate', methods=['POST'])
def translate_text():

    print(request)

    try:
        data = request.get_json()
        text_to_translate = data.get('text')
        target_language = data.get('target_language', 'en') # Default to English
    
        if not text_to_translate:
            return jsonify({'error': 'Missing "text" in request body'}), 400

        params = {
            'key': TRANSLATE_APP_API_KEY, 
            'q': text_to_translate,
            'target': target_language
        }

        response = requests.post(TRANSLATE_API_URL, params=params)
        response.raise_for_status() # Raise an exception for bad status codes (4xx or 5xx)

        result = response.json()

        # The structure of the response from the REST API is slightly different
        # It's usually: {'data': {'translations': [{'translatedText': '...', 'detectedSourceLanguage': '...'}]}}
        if 'data' in result and 'translations' in result['data'] and len(result['data']['translations']) > 0:
            translation_info = result['data']['translations'][0]
            return jsonify({
                'original_text': text_to_translate,
                'translated_text': translation_info['translatedText'],
                'detected_source_language': translation_info.get('detectedSourceLanguage')
            })
        else:
            return jsonify({'error': 'Unexpected response format from Translation API', 'details': result}), 500

    except requests.exceptions.HTTPError as http_err:
        print(f"HTTP error occurred: {http_err} - {response.text}")
        return jsonify({'error': f"Translation API request failed: {http_err}", 'details': response.text}), response.status_code
    except Exception as e:
        print(f"Error during translation: {e}")
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 8080))
    app.run(debug=True, host='0.0.0.0', port=port)
