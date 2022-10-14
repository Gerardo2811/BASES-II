CREATE OR REPLACE PACKAGE PQPROD IS
PROCEDURE ALTA_PRODUCTO(COD_PRODUCTO PRODUCTOS.COD_PRODUCTO%TYPE,NOMBRE_PRODUCTO PRODUCTOS.NOMBRE_PRODUCTO%TYPE,PVP PRODUCTOS.PVP%TYPE, TOTAL_VENDIDOS PRODUCTOS.TOTAL_VENDIDOS%TYPE);
PROCEDURE BAJA_PRODUCTO(COD_PRODUCTO PRODUCTOS.COD_PRODUCTO%TYPE);
PROCEDURE MOD_PROD(COD_PRODUCTO PRODUCTOS.COD_PRODUCTO%TYPE, NOMBRE_PRODUCTO PRODUCTOS.NOMBRE_PRODUCTO%TYPE);
FUNCTION NUM_FACTURAS(FECHA_INICIO FACTURAS.FECHA%TYPE, FECHA_FIN FACTURAS.FECHA%TYPE)RETURN NUMBER;
FUNCTION TOTAL_FACTURA(COD_FACTURA FACTURAS.COD_FACTURA%TYPE) RETURN NUMBER;
END;

SET SERVEROUTPUT ON


/*BODY DEL PACKAGE*/
CREATE OR REPLACE PACKAGE BODY PQPROD IS

  PROCEDURE ALTA_PRODUCTO(COD_PRODUCTO PRODUCTOS.COD_PRODUCTO%TYPE,NOMBRE_PRODUCTO PRODUCTOS.NOMBRE_PRODUCTO%TYPE,PVP PRODUCTOS.PVP%TYPE, TOTAL_VENDIDOS PRODUCTOS.TOTAL_VENDIDOS%TYPE) IS
    COD_PRODUCTO2 PRODUCTOS.COD_PRODUCTO%TYPE;
    NOMBRE_PRODUCTO2 PRODUCTOS.NOMBRE_PRODUCTO%TYPE;
    TOTAL_VENDIDOS2 PRODUCTOS.TOTAL_VENDIDOS%TYPE;
    PVP2 PRODUCTOS.PVP%TYPE;
  BEGIN
    COD_PRODUCTO2:=COD_PRODUCTO;
    NOMBRE_PRODUCTO2:=NOMBRE_PRODUCTO;
    TOTAL_VENDIDOS2:=TOTAL_VENDIDOS;
    PVP2:=PVP;
     INSERT INTO PRODUCTOS VALUES(COD_PRODUCTO2,NOMBRE_PRODUCTO2,PVP2,TOTAL_VENDIDOS2);
  END ALTA_PRODUCTO;

  
  PROCEDURE BAJA_PRODUCTO(COD_PRODUCTO PRODUCTOS.COD_PRODUCTO%TYPE)IS
    COD_PRODUCTO3 PRODUCTOS.COD_PRODUCTO%TYPE;
  BEGIN
      COD_PRODUCTO3:=COD_PRODUCTO;
      DELETE FROM PRODUCTOS WHERE COD_PRODUCTO3=PRODUCTOS.COD_PRODUCTO;
  END BAJA_PRODUCTO;
  
  PROCEDURE MOD_PROD(COD_PRODUCTO PRODUCTOS.COD_PRODUCTO%TYPE, NOMBRE_PRODUCTO PRODUCTOS.NOMBRE_PRODUCTO%TYPE) IS
    COD_PRODUCTO4 PRODUCTOS.COD_PRODUCTO%TYPE;
    NOMBRE_PRODUCTO4 PRODUCTOS.NOMBRE_PRODUCTO%TYPE;
  BEGIN
    COD_PRODUCTO4:=COD_PRODUCTO;
    NOMBRE_PRODUCTO4:=NOMBRE_PRODUCTO;
      UPDATE PRODUCTOS
        SET NOMBRE_PRODUCTO=NOMBRE_PRODUCTO4
      WHERE PRODUCTOS.COD_PRODUCTO=COD_PRODUCTO4;
  END MOD_PROD;
  
  FUNCTION NUM_FACTURAS(FECHA_INICIO FACTURAS.FECHA%TYPE, FECHA_FIN FACTURAS.FECHA%TYPE)RETURN NUMBER AS
    FECHA_INICIO2 FACTURAS.FECHA%TYPE;
    FECHA_FIN2 FACTURAS.FECHA%TYPE;
    CONTEO NUMBER;
  BEGIN
    FECHA_INICIO2:=FECHA_INICIO;
    FECHA_FIN2:=FECHA_FIN;
  SELECT COUNT(FECHA) INTO CONTEO FROM FACTURAS WHERE FECHA_INICIO2=TO_DATE(FECHA_INICIO2) AND FECHA_FIN2=TO_DATE(FECHA_FIN2) ;
    DBMS_OUTPUT.PUT_LINE('ESPERA');
    DBMS_OUTPUT.PUT_LINE(CONTEO);
    RETURN CONTEO;
  END NUM_FACTURAS;
  
  FUNCTION TOTAL_FACTURA(COD_FACTURA FACTURAS.COD_FACTURA%TYPE) RETURN NUMBER AS
    COD_FACTURA2 FACTURAS.COD_FACTURA%TYPE;
    TOTAL_FACTURA NUMBER;
  BEGIN
    COD_FACTURA2:=COD_FACTURA;
    SELECT SUM(LINEAS_FACTURA.PVP*LINEAS_FACTURA.UNIDADES)INTO TOTAL_FACTURA FROM LINEAS_FACTURA WHERE LINEAS_FACTURA.COD_FACTURA=COD_FACTURA2;
    DBMS_OUTPUT.PUT_LINE('SU TOTAL ES');
    DBMS_OUTPUT.PUT_LINE(TOTAL_FACTURA);
    RETURN TOTAL_FACTURA;
  END TOTAL_FACTURA;
  

END PQPROD;


/*BLOQUE ANONIMO*/
DECLARE
  FACTURAS_TOTALES NUMBER;
  TOTAL_VENTA NUMBER;
BEGIN
  PQPROD.ALTA_PRODUCTO(10,'CEPILLO MADERA ',5,NULL);
  PQPROD.ALTA_PRODUCTO(9,'TALADRO INDUSTRIAL',5,NULL);
  PQPROD.MOD_PROD(5,'SERRUCHO');
  FACTURAS_TOTALES:=PQPROD.NUM_FACTURAS('08-OCT-22','14-OCT-22');
  TOTAL_VENTA:=PQPROD.TOTAL_FACTURA(1);
  PQPROD.BAJA_PRODUCTO(6);
END;

/*TRIGGERS*/

/*INCISO A*/
CREATE OR REPLACE TRIGGER TR_REGISTRO 
BEFORE INSERT OR UPDATE OR DELETE ON FACTURAS
BEGIN
IF INSERTING THEN
  INSERT INTO CONTROL_LOG VALUES('FACTURAS',SYSDATE,USER,'INSERTAR');
  END IF;
  
  IF UPDATING THEN
   INSERT INTO CONTROL_LOG VALUES('FACTURAS',SYSDATE,USER,'UPDATE');
  END IF;
  
    IF DELETING THEN
   INSERT INTO CONTROL_LOG VALUES('FACTURAS',SYSDATE,USER,'DELETE');
  END IF;
END;
/
BEGIN
  INSERT INTO facturas (
    cod_factura,
    fecha,
    descripcion
) VALUES (
    22,
   Sysdate,
    'Factura 22'
);
END;
/
BEGIN
  UPDATE facturas
    SET DESCRIPCION='FACTURA 22.2'
    WHERE COD_FACTURA=22;
END;

BEGIN
  DELETE FROM FACTURAS WHERE COD_FACTURA=22;
END;

/*INCISO B*/

/*--------------------EJERCICIO NO COMPLETADO------------------------------*/
CREATE OR REPLACE TRIGGER TR_UPDATEPVP 
BEFORE UPDATE ON LINEAS_FACTURA FOR EACH ROW
BEGIN
  IF :NEW.PVP>:OLD.PVP THEN
    :NEW.PVP:=:NEW.PVP*2;
    UPDATE LINEAS_FACTURA
      SET PVP=:NEW.PVP
    WHERE :new.COD_PRODUCTO=:old.COD_PRODUCTO;
  END IF;
END;
/
UPDATE LINEAS_FACTURA
  SET PVP=20
WHERE COD_PRODUCTO=3;








