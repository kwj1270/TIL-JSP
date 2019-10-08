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
			String jdbcUrl = "jdbc:mysql://localhost:3306/chap14?serverTimezone=UTC";
			String dbUser="jspexam";
			String dbPass="jsppw";
		
			///////////////////////////// 커넥션 생성  /////////////////////////////
			
			// 커넥션 팩토리 -> 새로운 커넥션을 생성할 때 사용한다.   
			ConnectionFactory connFactory = 
				new DriverManagerConnectionFactory(jdbcUrl, dbUser, dbPass);
			
			// DBCP가 커넥션 풀에 커넥션을 보관할 때 사용하는 PoolableConnectionFactory 생성
			// 실제로 내부적으로 커넥션을 담고있고 커넥션을 관리하는 기능을 제공한다.  
			// 커넥션 풀에서는 커넥션.close 하면 종료하지 않고 다시 커넥션 풀로 반환 시키는 역할을 한다.  
			PoolableConnectionFactory poolableConnFactory = 
				new PoolableConnectionFactory(connFactory, null);
			
			// 아래 메소드는 커넥션이 유효한지를 검사하도록 한다.  
			// 커넥션이 유효하다는 것은 한편으로 유효시간이 지나지 않았다는 뜻이다.  
			// 만약 커넥션의 유효기간이 지났을 경우 에러를 발생했을 것이다.  
			// 정확히는 커넥션을 검사할 때 사용할 쿼리를 지정한다.  
			poolableConnFactory.setValidationQuery("select 1");
			
			////////////////////////////////////////////////////////////////////
			
			///////////////////////////// 풀 설정 정보  /////////////////////////////
			
			GenericObjectPoolConfig poolConfig = new GenericObjectPoolConfig();
			
			// 유휴 커넥션 검사 주기 & 풀에 있는 커넥션이 유효한지 검사 유무 설정
			poolConfig.setTimeBetweenEvictionRunsMillis(1000L * 60L * 5L);
			poolConfig.setTestWhileIdle(true);
			
			// 커넥션 최소 갯수 설정
			poolConfig.setMinIdle(4);
			
			// 커넥션 최대 갯수 설정
			poolConfig.setMaxTotal(50);
			
			////////////////////////////////////////////////////////////////////
			
			//////////////////////////// 커넥션 풀 생성 ////////////////////////////
			
			// 풀 설정 정보와 앞서 만든 (커넥션+관리)인 poolableConnFactory을 넣어서 생성한다.    
			GenericObjectPool<PoolableConnection> connectionPool =
				new GenericObjectPool<>(poolableConnFactory, poolConfig);
			
			// 뿐만 아니라 poolableConnFactory에도 커넥션 풀을 연결  
			// 즉 커넥션 풀에  poolableConnFactory을 넣고  
			// poolableConnFactory에도 풀을 지정해주어야 한다.  
			poolableConnFactory.setPool(connectionPool);
		
			// 커넥션 풀을 제공하는 JDBC 드라이버를 등록을 해준다. 
			Class.forName("org.apache.commons.dbcp2.PoolingDriver");
			
			// 커넥션 풀을 제공하는 JDBC 드라이버를 생성한다.  
			PoolingDriver driver = (PoolingDriver)
				DriverManager.getDriver("jdbc:apache:commons:dbcp:");
			
			// 커넥션 풀 드라이버에 생성한 커넥션 풀을 등록한다.
			driver.registerPool("chap14", connectionPool);
			
			////////////////////////////////////////////////////////////////////

		} catch(Exception e) {
			throw new RuntimeException(e);
		}
	}

}
