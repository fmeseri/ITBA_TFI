
##### USER DEFINED FUNCTIONS#######################
import psycopg2
import pandas as pd
import json
import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd
from matplotlib.colors import ListedColormap

## READ SQL TABLE TO PANDAS DF
def read_table_into_dataframe(table_name):
    

    # Establish connection parameters-- In this case for my AMBA database
    dbname = 'AMBA'
    user = 'postgres'
    password = 'Ferm1987'
    host = 'localhost'  # By default, localhost
    port = '5432'  # By default, 5432
    try:
        # Connect to the PostgreSQL database
        conn = psycopg2.connect(
            dbname=dbname,
            user=user,
            password=password,
            host=host,
            port=port
        )

        # Create a cursor object
        cursor = conn.cursor()

        # Execute a query to select data from the specified table
        query = f"SELECT * FROM {table_name};"
        cursor.execute(query)
        
        # Fetch all rows from the result set
        rows = cursor.fetchall()
        
        # Get the column names from the cursor description
        column_names = [desc[0] for desc in cursor.description]
        
        # Create a DataFrame from the fetched data and column names
        df = pd.DataFrame(rows, columns=column_names)

        return df

    except psycopg2.Error as e:
        print("Error connecting to PostgreSQL:", e)
        return None

    finally:
        # Close the cursor and connection
        if 'cursor' in locals() and cursor is not None:
            cursor.close()
        if 'conn' in locals() and conn is not None:
            conn.close()



################# CATEGORIZE COLUMNS POBLACION
def categorize_sup(sup):
    if sup <= 64:
        return 'pequeña'
    elif 65 < sup <= 104:
        return 'mediana'
    elif 105 < sup <= 228:
        return 'grande'
    elif sup > 228:
        return 'muy grande'

    
def categorize_dens_pob(dens):
    if dens <= 2000:
        return 'baja'
    elif 2000 < dens <= 4000:
        return 'media'
    elif 4000 < dens <= 6000:
        return 'media-alta'
    elif dens > 6000:
        return 'alta'
    
############### PRINT TABLE PDF
    import matplotlib.pyplot as plt

# Function to create a table visualization of the dataset
def create_table_pdf(data, filename):
    plt.figure(figsize=(10, 6))
    plt.axis('off')  # Hide axis
    plt.table(cellText=data.values, colLabels=data.columns, loc='center')
    plt.savefig(filename, bbox_inches='tight', pad_inches=0.5)


    
    
### table to LATEX

def dataframe_to_latex(df, filename='output.tex'):
    # """
    # Convert a pandas DataFrame to a LaTeX table and save it to a .tex file.

    # Parameters:
    # - df: pandas DataFrame
    # - filename: str, optional, default: 'output.tex'
    #     The filename (including path if necessary) to save the LaTeX table.
    # """
    with open(filename, 'w', encoding='utf-8') as f:  # Specify encoding as 'utf-8'
        f.write("\\begin{table}[htb]\n")
        f.write("\\centering\n")
        f.write("\\begin{tabular}{|" + "c|"*len(df.columns) + "}\n")
        f.write("\\hline\n")
        
        # # Write header row with bold text and background color
        # header = " & ".join("\\textbf{\\cellcolor[rgb]{0,0.231,0.427} " + str(col) + "}" for col in df.columns) + " \\\\"
        # f.write(header + "\n")
        # f.write("\\hline\n")
        
        # Write header row with bold text, background color, and white text color
        header = " & ".join("\\textbf{\\cellcolor[rgb]{0,0.231,0.427}\\textcolor{white}{" + str(col) + "}}" for col in df.columns) + " \\\\"
        f.write(header + "\n")
        f.write("\\hline\n")


        # Write data rows
        for row in df.values:
            row_str = " & ".join(str(val) for val in row) + " \\\\"
            f.write(row_str + "\n")
        
        f.write("\\hline\n")
        f.write("\\end{tabular}\n")
        f.write("\\caption{Your caption here}\n")
        f.write("\\label{tab:my_table}\n")
        f.write("\\end{table}\n")



############################

def dataframe_to_image(df, filename='output', image_format='svg'):
    fig, ax = plt.subplots(figsize=(12, 4))  # Adjust figsize as needed
    ax.axis('tight')
    ax.axis('off')

    table = ax.table(cellText=df.values, colLabels=df.columns, loc='center', cellLoc='center')

    # Define header properties
    header_props = dict(fontweight='bold', fontsize=10, color='white', backgroundcolor='skyblue')

    # Apply header properties to the header row
    for cell in table._cells:
        if cell[0] == 0:  # Header row
            table._cells[cell].set_text_props(**header_props)

    table.auto_set_font_size(False)
    table.scale(1.2, 1.2)   # Adjust scaling factor as needed

    # Save the plot as an image
    plt.savefig(f"{filename}.{image_format}", format=image_format, bbox_inches='tight')
