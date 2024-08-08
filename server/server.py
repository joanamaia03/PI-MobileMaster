from flask import Flask, redirect, request, jsonify, send_from_directory
from werkzeug.utils import secure_filename
from flask_cors import CORS  # Import CORS
import os
import uuid
import shutil

app = Flask(__name__)
CORS(app)
RESULT_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'results')
UPLOAD_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'uploads')
APPROVED_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'approved')
IMAGE_UPLOAD_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'images')



if not os.path.exists(UPLOAD_DIR):
    os.makedirs(UPLOAD_DIR)

@app.route('/upload', methods=['POST'])
def upload():
    if request.method == 'POST':
        data = request.json
        html_content = data.get('htmlContent')
        filename = data.get('filename') if data.get('filename') else str(uuid.uuid4())
        
        try:
            with open(os.path.join(UPLOAD_DIR, filename + '.html'), 'w') as file:
                file.write(html_content)
            return jsonify({'message': 'HTML uploaded successfully'}), 200
        except Exception as e:
            return jsonify({'error': str(e)}), 500
        
@app.route('/upload_image', methods=['POST'])
def upload_image():
    if 'image' not in request.files:
        return jsonify({'error': 'No image part in the request'}), 400

    image = request.files['image']
    filename = secure_filename(image.filename)
    
    try:
        image_path = os.path.join(IMAGE_UPLOAD_DIR, filename)
        image.save(image_path)
        return jsonify({'message': f'Image {filename} uploaded successfully'}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500
        
@app.route('/uploads', methods=['GET'])
def get_pages():
    files = [f for f in os.listdir(UPLOAD_DIR) if os.path.isfile(os.path.join(UPLOAD_DIR, f))]
    return jsonify(files), 200
    
@app.route('/uploads/<filename>', methods=['GET'])
def serve_file(filename):
    return send_from_directory(UPLOAD_DIR, filename)

@app.route('/results/<filename>', methods=['GET'])
def results_file(filename):
    return send_from_directory(RESULT_DIR, filename)

@app.route('/images/<filename>', methods=['GET'])
def serve_image(filename):
    return send_from_directory('images', filename)

@app.route('/approve', methods=['POST'])
def approve_file():
    data = request.json
    filename = data.get('filename')
    source = os.path.join(UPLOAD_DIR, filename + '.html')
    destination = os.path.join(APPROVED_DIR, filename + '.html')

    if not os.path.exists(source):
        return jsonify({'error': 'File not found'}), 404
    
    try:
        shutil.copy(source, destination)
        return jsonify({'message': 'File approved successfully'}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/<formpage>/submit_form', methods=['POST'])
def submit_form(formpage):
    # Receive data from the form
    test_value = request.form.to_dict()


    html_content = f"""
    <h2>{formpage}</h2>"""
    for key,value in test_value.items():
            html_content += f"""<p>{key}: {value}</p>"""

    # Generate a unique filename (optional: use UUID or timestamp)
    filename = 'results.html'

    # Save HTML content to a file
    file_path = os.path.join(RESULT_DIR, filename)
    with open(file_path, 'a') as file:
        file.write(html_content)

    return redirect("/uploads/page1.html")
        
if __name__ == '__main__':
    app.run(debug=True, port=5000)
