package jdbc;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;

import org.apache.commons.dbcp2.BasicDataSource;
import org.apache.commons.dbcp2.BasicDataSourceFactory;
import org.apache.commons.dbcp2.ConnectionFactory;
import org.apache.commons.dbcp2.DriverManagerConnectionFactory;
import org.apache.commons.dbcp2.PoolableConnection;
import org.apache.commons.dbcp2.PoolableConnectionFactory;
import org.apache.commons.dbcp2.PoolingDriver;
import org.apache.commons.pool2.ObjectPool;
import org.apache.commons.pool2.impl.GenericObjectPool;
import org.apache.commons.pool2.impl.GenericObjectPoolConfig;

public class DBCPInit extends HttpServlet {

	@Override
	public void init() throws ServletException {
		loadJDBCDriver();
		initConnectionPool();
	}

	private void loadJDBCDriver() {
		try {
			Class.forName("com.mysql.jdbc.Driver");
		} catch (ClassNotFoundException ex) {
			throw new RuntimeException("fail to load JDBC Driver", ex);
		}
	}

	private void initConnectionPool() {
		try {	
			String jdbcUrl = "jdbc:mysql://localhost:3306/jjuniv?serverTimezone=UTC";
			String dbUser="root";
			String dbPass="1234";
		
			ConnectionFactory connFactory = 
				new DriverManagerConnectionFactory(jdbcUrl, dbUser, dbPass);
			PoolableConnectionFactory poolableConnFactory = 
				new PoolableConnectionFactory(connFactory, null);
			poolableConnFactory.setValidationQuery("select 1");
		
			GenericObjectPoolConfig poolConfig = new GenericObjectPoolConfig();
			poolConfig.setTimeBetweenEvictionRunsMillis(1000L * 60L * 5L);
			poolConfig.setTestWhileIdle(true);
			poolConfig.setMinIdle(4);
			poolConfig.setMaxTotal(50);
		
			GenericObjectPool<PoolableConnection> connectionPool =
				new GenericObjectPool<>(poolableConnFactory, poolConfig);
			poolableConnFactory.setPool(connectionPool);
		
			Class.forName("org.apache.commons.dbcp2.PoolingDriver");
			PoolingDriver driver = (PoolingDriver)
				DriverManager.getDriver("jdbc:apache:commons:dbcp:");
			driver.registerPool("jjuniv", connectionPool);
		} catch(Exception e) {
			throw new RuntimeException(e);
		}
	}

}
