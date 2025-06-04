from flask import Flask, jsonify
app = Flask(__name__)

@app.route('/health', methods=['GET'])
def health():
    return jsonify(status='ETL Healthy', time=str(__import__('datetime').datetime.utcnow()))

if __name__ == '__main__':
    app.run(port=5100)
