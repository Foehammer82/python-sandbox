"""PDF Tools for enhancing PDF documents.

This Streamlit page provides a web interface for PDF processing utilities.
Users can upload PDFs, apply various enhancements, and download the processed versions.

Features:
    - Converting regular PDFs to searchable PDFs using OCR technology

Example:
    To run this module directly from the command line:
    
    ```
    streamlit run pdf_tools.py
    ```

Notes:
    Requires the OCRmyPDF library which depends on Tesseract OCR engine.
"""

# ===== IMPORTS =====
from io import BytesIO
from pathlib import Path

import ocrmypdf
import streamlit as st


# ===== PAGE HEADER =====
st.set_page_config(
    page_title="PDF Tools",
    page_icon="📄",
)
st.title("PDF Tools")


# ===== PDF TO SEARCHABLE PDF SECTION =====
st.subheader("Convert PDF to Searchable PDF")

# File upload component
uploaded_file = st.file_uploader("Choose a file")

# Process button
if st.button("Convert PDF", use_container_width=True):
    # Validate input file
    if uploaded_file is not None:
        # Check if the uploaded file is a PDF
        if uploaded_file.type != "application/pdf":
            st.error("Please upload a valid PDF file.")
            st.stop()

        # Process the PDF with OCR
        with st.spinner("Processing PDF...", show_time=True):
            output_pdf = BytesIO()
            ocrmypdf.ocr(
                input_file=BytesIO(uploaded_file.getvalue()),  # Convert uploaded file to bytes
                output_file=output_pdf,                        # Store output in memory
            )

        # Create download button for processed PDF
        output_file_name = Path(uploaded_file.name).stem + " (searchable).pdf"
        st.download_button(
            label=f"Download `{output_file_name}`",
            data=output_pdf,
            file_name=output_file_name,
            mime="application/pdf",
            icon=":material/download:",
            use_container_width=True,
        )

    else:
        # Handle missing file error
        st.error("Please upload a file.")
        st.stop()
