import pandas as pd


class DataProcessor:
    """
    Clase para procesar datos desde archivos CSV con manejo de fechas.

    Attributes
    ----------
    file_path : str
        Ruta al archivo CSV.
    date_column : str
        Nombre de la columna que contiene las fechas.
    date_format : str
        Formato de las fechas en el archivo CSV.
    sep : str, optional
        Separador de las columnas en el archivo CSV, por defecto ";".
    encoding : str, optional
        Codificación del archivo CSV, por defecto "utf-8".
    data : pd.DataFrame
        DataFrame con los datos cargados y procesados.
    """

    def __init__(  # noqa: PLR0913
        self,
        file_path,
        date_column,
        date_format,
        sep=";",
        encoding="utf-8",
    ):
        """
        __init__ Inicializa la clase DataProcessor.

        Inicializa la clase con los parámetros necesarios para cargar y procesar datos.

        Parameters
        ----------
        file_path : str
            Ruta al archivo CSV.
        date_column : str
            Nombre de la columna que contiene las fechas.
        date_format : str
            Formato de las fechas en el archivo CSV.
        sep : str, optional
            Separador de las columnas, por defecto ";".
        encoding : str, optional
            Codificación del archivo CSV, por defecto "utf-8".
        """
        self.file_path = file_path
        self.date_column = date_column
        self.date_format = date_format
        self.sep = sep
        self.encoding = encoding
        self.data = None

    def load_data(self):
        """
        load_data Carga los datos desde el archivo CSV.

        Lee los datos desde la ruta especificada y los almacena en un DataFrame.

        Raises
        ------
        FileNotFoundError
            Si el archivo no se encuentra en la ruta especificada.
        """
        try:
            self.data = pd.read_csv(self.file_path, sep=self.sep, encoding=self.encoding)
        except FileNotFoundError as e:
            raise FileNotFoundError(f"Archivo no encontrado: {self.file_path}") from e

    def process_dates(self):
        """
        process_dates Procesa la columna de fechas en el DataFrame.

        Convierte la columna de fechas al formato datetime, crea una nueva columna
        para análisis mensual ('FechaMensual') y establece la columna de fecha
        como índice del DataFrame.

        Raises
        ------
        ValueError
            Si los datos no se han cargado antes de procesar.
        """
        if self.data is not None:
            self.data[self.date_column] = self.data[self.date_column].str.strip()
            self.data[self.date_column] = pd.to_datetime(
                self.data[self.date_column], format=self.date_format
            )
            self.data["FechaMensual"] = (
                self.data[self.date_column].dt.to_period("M").dt.to_timestamp()
            )
            self.data = self.data.set_index(self.date_column)
        else:
            raise ValueError("Los datos no se han cargado. Llame a 'load_data' primero.")

    def get_data(self):
        """
        get_data Devuelve el DataFrame procesado.

        Returns
        -------
        pd.DataFrame
            DataFrame con los datos procesados.

        Raises
        ------
        ValueError
            Si el DataFrame no está procesado o no se ha cargado.
        """
        if self.data is not None:
            return self.data
        else:
            raise ValueError(
                "El DataFrame no está procesado. Asegúrese de cargar y procesar los datos primero."
            )


# Ejemplo de uso
if __name__ == "__main__":
    # Procesar MMA_desinventar.csv
    mma_processor = DataProcessor(
        file_path="../data/processed/MMA_desinventar.csv",
        date_column="Fecha",
        date_format="%d/%m/%y",
    )
    mma_processor.load_data()
    mma_processor.process_dates()
    mma_df = mma_processor.get_data()
    print("Datos procesados de MMA:")
    print(mma_df.head())

    # Procesar lluvias_nivel_ideam.csv
    lluvias_processor = DataProcessor(
        file_path="../data/processed/lluvias_nivel_ideam.csv",
        date_column="Fecha",
        date_format="%d/%m/%y",
    )
    lluvias_processor.load_data()
    lluvias_processor.process_dates()
    lluvias_df = lluvias_processor.get_data()
    print("Datos procesados de lluvias:")
    print(lluvias_df.head())
