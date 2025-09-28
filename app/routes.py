from flask import Blueprint, render_template, request
from datetime import datetime

bp = Blueprint("main", __name__)

@bp.route("/")
def index():
    return render_template(
        "index.html",
        time=datetime.utcnow(),
        headers=request.headers,
        ip=request.remote_addr
    )
